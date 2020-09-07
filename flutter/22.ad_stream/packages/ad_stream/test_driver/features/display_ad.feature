Feature: Display Ad
    Ads that matched targeting values should be displayed when all services are ready

    Scenario: no passenger information
        Given I am passenger
        Then I see an Ad is displaying

    # Scenario: ads by passenger gender and age range
    #     Given I am 24 years old passenger
    #     And I am male
    #     Then I see Ads that matched my gender and age range are displayed
