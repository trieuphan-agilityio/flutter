import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();

export const helloWorld = functions.https.onRequest((req, res) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    res.send("Hello from Firebase!");
});

export const aggregateRatings = functions.firestore
    .document('restaurants/{restId}/ratings/{ratingId}')
    .onWrite(async (snap, context) => {
        // Get value of the newly added rating
        const boxedData = snap.after.data();

        if (boxedData == undefined) return;

        const ratingVal = boxedData.rating;

        // Get a reference to the restaurant
        const restRef = db.collection('restaurants').doc(context.params.restId);

        // Update aggregations in a transaction
        await db.runTransaction(async (transaction) => {
            const restDoc = await transaction.get(restRef);

            const boxedData = restDoc.data();

            if (boxedData == undefined) return;

            // Compute new number of ratings
            const newNumRatings = boxedData.numRatings + 1;

            // Compute new average rating
            const oldRatingTotal = boxedData.avgRating * boxedData.numRatings;
            const newAvgRating = (oldRatingTotal + ratingVal) / newNumRatings;

            // Update restaurant info
            transaction.update(restRef, {
                avgRating: newAvgRating,
                numRatings: newNumRatings
            });
        });
    });
