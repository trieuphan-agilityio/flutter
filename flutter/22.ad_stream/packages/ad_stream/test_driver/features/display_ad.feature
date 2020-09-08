Feature: Display Ad
    Ads that matched targeting values will be displayed

    Scenario: Advertise at shopping mall
        Given I am a visitor
        Then I see an ad is displaying

    Scenario: Skip ad
        Given I am seeing an ad
        When I tap on skip button
        Then I see the ad is skipped

    Scenario: Advertise in taxi
        Given Driver pick up a passenger
        When Driver is driving from 10 Xuan Thuy to 218 Xuan Thuy
        Then Passengers sees ads that matched their gender and age range are displayed

    Scenario: Trip is dropped off
        Given Passenger is about to finish a trip
        When Passenger is dropped off
        Then No ads is showing
