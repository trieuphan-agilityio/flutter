Feature: Display ad in taxi

    As a Passenger
    I want to see ads that matched my gender and 
    age range will be displayed

    Background:
        Given Driver onboarded
        And Passenger booked a trip on "Sep 12, 2020 at 11:16 am"

    Scenario: Female passenger is on trip
        Given I am 26 years old, a "female" passenger
        When Driver drives me "from 10 Xuan Thuy to 218 Xuan Thuy"
        Then I see an "ad" is displaying
        And The displaying ad targets to "female" audience
        And The displaying ad targets to age range that includes 26

    Scenario: Group of passengers are on trip
        Given We are group of passengers, our photo is located at "assets/camera-sample_1.jpg"
        When Driver drives us "from 10 Xuan Thuy to 218 Xuan Thuy"
        Then We see an "ad" is displaying
        And The displaying ad targets to "female" audience
        And The displaying ad targets to "male" audience
        And The displaying ad targets to age range that includes 24
        And The displaying ad targets to age range that includes 29

    Scenario: Trip is dropped off
        Given I am about to finish my trip
        When I am dropped off
        Then I see a "screensaver" is displaying
