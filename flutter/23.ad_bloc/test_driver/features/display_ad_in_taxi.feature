Feature: Display ad in taxi

    As a Passenger
    I want to see ads that matched my gender and 
    age range will be displayed

    Background:
        Given In test environment
        And Driver onboarded
        And Driver picked me up on "Sep 12, 2020 at 11:16 am"

    Scenario: Female passenger is on trip
        Given My photo is located at "assets/camera-sample_2.png"
        When Driver drives me "from 496 Ngo Quyen to 604 Nui Thanh"
        Then I see the following ads are displaying:
            |Ad Id       |Duration (s) |Can skip? |
            |screensaver |2            |nope      |
            |7bfe403     |4            |yes       |
            |2a578       |4            |yes       |
            |b65ba       |2            |nope      |
            |70115       |2            |yes       |
            |15bf44c     |4            |nope      |
            |ac38445     |4            |yes       |

    Scenario: Group of passengers are on trip
        Given We are group of passengers, our photo is located at "assets/camera-sample_1.png"
        When Driver drives us "from 496 Ngo Quyen to 604 Nui Thanh"
        Then We see the following ads are displaying:
            |Ad Id       |Duration (s) |Can skip? |
            |screensaver |2            |nope      |
            |7bfe403     |4            |yes       |
            |15bf44c     |4            |nope      |
            |2d8056e     |2            |yes       |
            |b30d3b2     |4            |yes       |
            |5b4c3       |4            |yes       |

    # Scenario: Trip is dropped off
    #     Given I am about to finish my trip
    #     When I am dropped off
    #     Then I see a "screensaver" is displaying
