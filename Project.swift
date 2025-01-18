import ProjectDescription

let defaultInfoPlist: InfoPlist = .extendingDefault(
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
      )

let project = Project(
    name: "onboardingProject",
    targets: [
        .target(
            name: "onboardingProject",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.onboardingProject",
            infoPlist: defaultInfoPlist,
            sources: ["onboardingProject/Sources/**"],
            resources: ["onboardingProject/Resources/**"],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "Then"),
                .external(name: "SnapKit"),
                .external(name: "RxCocoa")
            ],
            coreDataModels: [
                CoreDataModel.coreDataModel(
                    "onboardingProject/Sources/CoreDataModel/onboardingProject.xcdatamodeld"
                )
            ]
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
