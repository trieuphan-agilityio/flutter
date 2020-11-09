import * as functions from 'firebase-functions';

export const helloWorld = functions.https.onRequest((req, res) => {
    functions.logger.info("Hello logs!", {structuredData: true});
    res.send("Hello from Firebase!");
});

// Define a Firestore-triggered functions

export const  createUser = functions.firestore
    .document('users/{userId}')
    .onCreate((snap, context) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const newValue = snap.data();

        functions.logger.info('Uppercasing', context.params.userId, newValue.name)

        // access a particular field as you would any JS property
        const uppercase = newValue.name.toUpperCase();

        // Setting an 'uppercase' field in Cloud Firestore document
        return snap.ref.set({uppercase}, {merge: true});
    });
