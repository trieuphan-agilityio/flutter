Feature: Display ad in taxi
    Ads that matched passenger information will be displayed

    Scenario: Female passenger is on trip
        Given Driver pick up a "female" passenger
        And Passenger is 24 years old
        When Driver is driving "from 10 Xuan Thuy to 218 Xuan Thuy"
        Then Passenger sees an ad is displaying
        And The displaying ad targets to "female" audience
        And The displaying ad targets to age range that includes 24

    # Scenario: Trip is dropped off
    #     Given Passenger is about to finish a trip
    #     When Passenger is dropped off
    #     Then No ads is showing
