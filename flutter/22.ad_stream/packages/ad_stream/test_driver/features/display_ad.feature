Feature: Display ad in shopping mall
    Ads is displayed on TV, Display Panel.

    Scenario: Advertise at shopping mall
        Given I am a visitor
        Then I see an ad is displaying

    # Scenario: Skip video ad
    #     Given I am seeing an video ad is playing
    #     When I tap on skip button
    #     Then I see the ad is skipped
