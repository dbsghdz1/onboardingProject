import ProjectDescription

let project = Project(
    name: "onboardingProject",
    targets: [
        .target(
            name: "onboardingProject",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.onboardingProject",
            infoPlist: .extendingDefault(
                            with: [
                              "UILaunchStoryboardName": "LaunchScreen.storyboard",
                                      "UIApplicationSceneManifest": [
                                          "UIApplicationSupportsMultipleScenes": false,
                                          "UISceneConfigurations": [
                                              "UIWindowSceneSessionRoleApplication": [
                                                  [
                                                      "UISceneConfigurationName": "Default Configuration",
                                                      "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                                  ],
                                              ]
                                          ]
                                      ],
                                  ]
                              ),

            sources: ["onboardingProject/Sources/**"],
            resources: ["onboardingProject/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "onboardingProjectTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.onboardingProjectTests",
            infoPlist: .default,
            sources: ["onboardingProject/Tests/**"],
            resources: [],
            dependencies: [.target(name: "onboardingProject")]
        ),
    ]
)
