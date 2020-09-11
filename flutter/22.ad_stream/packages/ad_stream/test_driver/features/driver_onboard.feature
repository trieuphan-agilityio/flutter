Feature: Driver onboards

    As a Driver
    I want to set up my device to serve ad
    so that I can monetize while driving with passengers

    Scenario: Driver is asked to grant permission on device
        Given I open the app for the first time
        Then I see a "permission requester UI" is displaying

    Scenario: Driver onboards
        Given I opened the app and a "permission requester UI" is displaying
        When I grant permission
        Then I see a "screensaver" is displaying

    Scenario: Driver locked the car
        Given I turned off the power of the car
        Then I expect a "screensaver" is displaying

    Scenario: Driver is waiting for passenger
        Given I drive without passenger 
        Then I expect a "screensaver" is displaying
