#!/usr/bin/env python3
"""Generate the Flow Design Xcode project from the repo source layout."""

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PROJECT_DIR = ROOT / "FlowDesign.xcodeproj"
SCHEME_DIR = PROJECT_DIR / "xcshareddata" / "xcschemes"


PROJECT_PBXPROJ = """// !$*UTF8*$!
{
\tarchiveVersion = 1;
\tclasses = {
\t};
\tobjectVersion = 56;
\tobjects = {

/* Begin PBXBuildFile section */
\t\tA00100000000000000000001 /* FlowDesignApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = A00100000000000000000021 /* FlowDesignApp.swift */; };
\t\tA00100000000000000000002 /* FlowDesignDocument.swift in Sources */ = {isa = PBXBuildFile; fileRef = A00100000000000000000022 /* FlowDesignDocument.swift */; };
\t\tA00100000000000000000003 /* PaperMarkupHost.swift in Sources */ = {isa = PBXBuildFile; fileRef = A00100000000000000000023 /* PaperMarkupHost.swift */; };
\t\tA00100000000000000000004 /* FlowDesignDocumentTests.swift in Sources */ = {isa = PBXBuildFile; fileRef = A00100000000000000000024 /* FlowDesignDocumentTests.swift */; };
\t\tA00100000000000000000005 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = A00100000000000000000025 /* Assets.xcassets */; };
\t\tA00100000000000000000006 /* FlowDesignCore.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = A00100000000000000000031 /* FlowDesignCore.framework */; };
\t\tA00100000000000000000007 /* FlowDesignPaperKit.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = A00100000000000000000032 /* FlowDesignPaperKit.framework */; };
\t\tA00100000000000000000008 /* FlowDesignCore.framework in Embed Frameworks */ = {isa = PBXBuildFile; fileRef = A00100000000000000000031 /* FlowDesignCore.framework */; settings = {ATTRIBUTES = (CodeSignOnCopy, RemoveHeadersOnCopy, ); }; };
\t\tA00100000000000000000009 /* FlowDesignPaperKit.framework in Embed Frameworks */ = {isa = PBXBuildFile; fileRef = A00100000000000000000032 /* FlowDesignPaperKit.framework */; settings = {ATTRIBUTES = (CodeSignOnCopy, RemoveHeadersOnCopy, ); }; };
\t\tA0010000000000000000000A /* FlowDesignCore.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = A00100000000000000000031 /* FlowDesignCore.framework */; };
\t\tA0010000000000000000000B /* FlowDesignCore.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = A00100000000000000000031 /* FlowDesignCore.framework */; };
/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
\t\tA00100000000000000000041 /* PBXContainerItemProxy */ = {isa = PBXContainerItemProxy; containerPortal = A00100000000000000000060 /* Project object */; proxyType = 1; remoteGlobalIDString = A00100000000000000000071; remoteInfo = FlowDesignCore; };
\t\tA00100000000000000000042 /* PBXContainerItemProxy */ = {isa = PBXContainerItemProxy; containerPortal = A00100000000000000000060 /* Project object */; proxyType = 1; remoteGlobalIDString = A00100000000000000000072; remoteInfo = FlowDesignPaperKit; };
\t\tA00100000000000000000043 /* PBXContainerItemProxy */ = {isa = PBXContainerItemProxy; containerPortal = A00100000000000000000060 /* Project object */; proxyType = 1; remoteGlobalIDString = A00100000000000000000071; remoteInfo = FlowDesignCore; };
\t\tA00100000000000000000044 /* PBXContainerItemProxy */ = {isa = PBXContainerItemProxy; containerPortal = A00100000000000000000060 /* Project object */; proxyType = 1; remoteGlobalIDString = A00100000000000000000071; remoteInfo = FlowDesignCore; };
/* End PBXContainerItemProxy section */

/* Begin PBXCopyFilesBuildPhase section */
\t\tA00100000000000000000051 /* Embed Frameworks */ = {
\t\t\tisa = PBXCopyFilesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tdstPath = "";
\t\t\tdstSubfolderSpec = 10;
\t\t\tfiles = (
\t\t\t\tA00100000000000000000008 /* FlowDesignCore.framework in Embed Frameworks */,
\t\t\t\tA00100000000000000000009 /* FlowDesignPaperKit.framework in Embed Frameworks */,
\t\t\t);
\t\t\tname = "Embed Frameworks";
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXCopyFilesBuildPhase section */

/* Begin PBXFileReference section */
\t\tA00100000000000000000020 /* FlowDesign.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = FlowDesign.app; sourceTree = BUILT_PRODUCTS_DIR; };
\t\tA00100000000000000000021 /* FlowDesignApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FlowDesignApp.swift; sourceTree = "<group>"; };
\t\tA00100000000000000000022 /* FlowDesignDocument.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FlowDesignDocument.swift; sourceTree = "<group>"; };
\t\tA00100000000000000000023 /* PaperMarkupHost.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = PaperMarkupHost.swift; sourceTree = "<group>"; };
\t\tA00100000000000000000024 /* FlowDesignDocumentTests.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FlowDesignDocumentTests.swift; sourceTree = "<group>"; };
\t\tA00100000000000000000025 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
\t\tA00100000000000000000026 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
\t\tA00100000000000000000027 /* FlowDesign.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = FlowDesign.entitlements; sourceTree = "<group>"; };
\t\tA00100000000000000000031 /* FlowDesignCore.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; includeInIndex = 0; path = FlowDesignCore.framework; sourceTree = BUILT_PRODUCTS_DIR; };
\t\tA00100000000000000000032 /* FlowDesignPaperKit.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; includeInIndex = 0; path = FlowDesignPaperKit.framework; sourceTree = BUILT_PRODUCTS_DIR; };
\t\tA00100000000000000000033 /* FlowDesignCoreTests.xctest */ = {isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = FlowDesignCoreTests.xctest; sourceTree = BUILT_PRODUCTS_DIR; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\tA00100000000000000000081 /* Frameworks */ = {isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (A00100000000000000000006 /* FlowDesignCore.framework in Frameworks */, A00100000000000000000007 /* FlowDesignPaperKit.framework in Frameworks */, ); runOnlyForDeploymentPostprocessing = 0; };
\t\tA00100000000000000000082 /* Frameworks */ = {isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; };
\t\tA00100000000000000000083 /* Frameworks */ = {isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (A0010000000000000000000A /* FlowDesignCore.framework in Frameworks */, ); runOnlyForDeploymentPostprocessing = 0; };
\t\tA00100000000000000000084 /* Frameworks */ = {isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (A0010000000000000000000B /* FlowDesignCore.framework in Frameworks */, ); runOnlyForDeploymentPostprocessing = 0; };
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
\t\tA00100000000000000000090 = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\tA00100000000000000000091 /* Sources */,
\t\t\t\tA00100000000000000000095 /* Tests */,
\t\t\t\tA00100000000000000000097 /* Resources */,
\t\t\t\tA00100000000000000000099 /* Products */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t};
\t\tA00100000000000000000091 /* Sources */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\tA00100000000000000000092 /* FlowDesignApp */,
\t\t\t\tA00100000000000000000093 /* FlowDesignCore */,
\t\t\t\tA00100000000000000000094 /* FlowDesignPaperKit */,
\t\t\t);
\t\t\tpath = Sources;
\t\t\tsourceTree = "<group>";
\t\t};
\t\tA00100000000000000000092 /* FlowDesignApp */ = {isa = PBXGroup; children = (A00100000000000000000021 /* FlowDesignApp.swift */, ); path = FlowDesignApp; sourceTree = "<group>"; };
\t\tA00100000000000000000093 /* FlowDesignCore */ = {isa = PBXGroup; children = (A00100000000000000000022 /* FlowDesignDocument.swift */, ); path = FlowDesignCore; sourceTree = "<group>"; };
\t\tA00100000000000000000094 /* FlowDesignPaperKit */ = {isa = PBXGroup; children = (A00100000000000000000023 /* PaperMarkupHost.swift */, ); path = FlowDesignPaperKit; sourceTree = "<group>"; };
\t\tA00100000000000000000095 /* Tests */ = {isa = PBXGroup; children = (A00100000000000000000096 /* FlowDesignCoreTests */, ); path = Tests; sourceTree = "<group>"; };
\t\tA00100000000000000000096 /* FlowDesignCoreTests */ = {isa = PBXGroup; children = (A00100000000000000000024 /* FlowDesignDocumentTests.swift */, ); path = FlowDesignCoreTests; sourceTree = "<group>"; };
\t\tA00100000000000000000097 /* Resources */ = {isa = PBXGroup; children = (A00100000000000000000025 /* Assets.xcassets */, A00100000000000000000026 /* Info.plist */, A00100000000000000000027 /* FlowDesign.entitlements */, ); path = Resources; sourceTree = "<group>"; };
\t\tA00100000000000000000099 /* Products */ = {isa = PBXGroup; children = (A00100000000000000000020 /* FlowDesign.app */, A00100000000000000000031 /* FlowDesignCore.framework */, A00100000000000000000032 /* FlowDesignPaperKit.framework */, A00100000000000000000033 /* FlowDesignCoreTests.xctest */, ); name = Products; sourceTree = "<group>"; };
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\tA00100000000000000000070 /* FlowDesign */ = {
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = A001000000000000000000B0 /* Build configuration list for PBXNativeTarget "FlowDesign" */;
\t\t\tbuildPhases = (A001000000000000000000A0 /* Sources */, A00100000000000000000081 /* Frameworks */, A001000000000000000000A4 /* Resources */, A00100000000000000000051 /* Embed Frameworks */, );
\t\t\tbuildRules = ();
\t\t\tdependencies = (A001000000000000000000C1 /* PBXTargetDependency */, A001000000000000000000C2 /* PBXTargetDependency */, );
\t\t\tname = FlowDesign;
\t\t\tproductName = FlowDesign;
\t\t\tproductReference = A00100000000000000000020 /* FlowDesign.app */;
\t\t\tproductType = "com.apple.product-type.application";
\t\t};
\t\tA00100000000000000000071 /* FlowDesignCore */ = {
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = A001000000000000000000B1 /* Build configuration list for PBXNativeTarget "FlowDesignCore" */;
\t\t\tbuildPhases = (A001000000000000000000A1 /* Sources */, A00100000000000000000082 /* Frameworks */, );
\t\t\tbuildRules = ();
\t\t\tdependencies = ();
\t\t\tname = FlowDesignCore;
\t\t\tproductName = FlowDesignCore;
\t\t\tproductReference = A00100000000000000000031 /* FlowDesignCore.framework */;
\t\t\tproductType = "com.apple.product-type.framework";
\t\t};
\t\tA00100000000000000000072 /* FlowDesignPaperKit */ = {
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = A001000000000000000000B2 /* Build configuration list for PBXNativeTarget "FlowDesignPaperKit" */;
\t\t\tbuildPhases = (A001000000000000000000A2 /* Sources */, A00100000000000000000083 /* Frameworks */, );
\t\t\tbuildRules = ();
\t\t\tdependencies = (A001000000000000000000C3 /* PBXTargetDependency */, );
\t\t\tname = FlowDesignPaperKit;
\t\t\tproductName = FlowDesignPaperKit;
\t\t\tproductReference = A00100000000000000000032 /* FlowDesignPaperKit.framework */;
\t\t\tproductType = "com.apple.product-type.framework";
\t\t};
\t\tA00100000000000000000073 /* FlowDesignCoreTests */ = {
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = A001000000000000000000B3 /* Build configuration list for PBXNativeTarget "FlowDesignCoreTests" */;
\t\t\tbuildPhases = (A001000000000000000000A3 /* Sources */, A00100000000000000000084 /* Frameworks */, );
\t\t\tbuildRules = ();
\t\t\tdependencies = (A001000000000000000000C4 /* PBXTargetDependency */, );
\t\t\tname = FlowDesignCoreTests;
\t\t\tproductName = FlowDesignCoreTests;
\t\t\tproductReference = A00100000000000000000033 /* FlowDesignCoreTests.xctest */;
\t\t\tproductType = "com.apple.product-type.bundle.unit-test";
\t\t};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\tA00100000000000000000060 /* Project object */ = {
\t\t\tisa = PBXProject;
\t\t\tattributes = {
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastSwiftUpdateCheck = 2650;
\t\t\t\tLastUpgradeCheck = 2650;
\t\t\t\tTargetAttributes = {
\t\t\t\t\tA00100000000000000000070 = {CreatedOnToolsVersion = 26.5; };
\t\t\t\t\tA00100000000000000000071 = {CreatedOnToolsVersion = 26.5; };
\t\t\t\t\tA00100000000000000000072 = {CreatedOnToolsVersion = 26.5; };
\t\t\t\t\tA00100000000000000000073 = {CreatedOnToolsVersion = 26.5; };
\t\t\t\t};
\t\t\t};
\t\t\tbuildConfigurationList = A001000000000000000000B4 /* Build configuration list for PBXProject "FlowDesign" */;
\t\t\tcompatibilityVersion = "Xcode 14.0";
\t\t\tdevelopmentRegion = en;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (en, Base, );
\t\t\tmainGroup = A00100000000000000000090;
\t\t\tproductRefGroup = A00100000000000000000099 /* Products */;
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (A00100000000000000000070 /* FlowDesign */, A00100000000000000000071 /* FlowDesignCore */, A00100000000000000000072 /* FlowDesignPaperKit */, A00100000000000000000073 /* FlowDesignCoreTests */, );
\t\t};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
\t\tA001000000000000000000A4 /* Resources */ = {isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = (A00100000000000000000005 /* Assets.xcassets in Resources */, ); runOnlyForDeploymentPostprocessing = 0; };
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
\t\tA001000000000000000000A0 /* Sources */ = {isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (A00100000000000000000001 /* FlowDesignApp.swift in Sources */, ); runOnlyForDeploymentPostprocessing = 0; };
\t\tA001000000000000000000A1 /* Sources */ = {isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (A00100000000000000000002 /* FlowDesignDocument.swift in Sources */, ); runOnlyForDeploymentPostprocessing = 0; };
\t\tA001000000000000000000A2 /* Sources */ = {isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (A00100000000000000000003 /* PaperMarkupHost.swift in Sources */, ); runOnlyForDeploymentPostprocessing = 0; };
\t\tA001000000000000000000A3 /* Sources */ = {isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (A00100000000000000000004 /* FlowDesignDocumentTests.swift in Sources */, ); runOnlyForDeploymentPostprocessing = 0; };
/* End PBXSourcesBuildPhase section */

/* Begin PBXTargetDependency section */
\t\tA001000000000000000000C1 /* PBXTargetDependency */ = {isa = PBXTargetDependency; target = A00100000000000000000071 /* FlowDesignCore */; targetProxy = A00100000000000000000041 /* PBXContainerItemProxy */; };
\t\tA001000000000000000000C2 /* PBXTargetDependency */ = {isa = PBXTargetDependency; target = A00100000000000000000072 /* FlowDesignPaperKit */; targetProxy = A00100000000000000000042 /* PBXContainerItemProxy */; };
\t\tA001000000000000000000C3 /* PBXTargetDependency */ = {isa = PBXTargetDependency; target = A00100000000000000000071 /* FlowDesignCore */; targetProxy = A00100000000000000000043 /* PBXContainerItemProxy */; };
\t\tA001000000000000000000C4 /* PBXTargetDependency */ = {isa = PBXTargetDependency; target = A00100000000000000000071 /* FlowDesignCore */; targetProxy = A00100000000000000000044 /* PBXContainerItemProxy */; };
/* End PBXTargetDependency section */

/* Begin XCBuildConfiguration section */
\t\tA001000000000000000000D0 /* Debug */ = {isa = XCBuildConfiguration; buildSettings = {ALWAYS_SEARCH_USER_PATHS = NO; CLANG_ANALYZER_NONNULL = YES; CLANG_ENABLE_MODULES = YES; CLANG_ENABLE_OBJC_ARC = YES; CLANG_WARN_DOCUMENTATION_COMMENTS = YES; CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES; CODE_SIGNING_ALLOWED = NO; DEBUG_INFORMATION_FORMAT = dwarf; ENABLE_STRICT_OBJC_MSGSEND = YES; ENABLE_TESTABILITY = YES; GCC_C_LANGUAGE_STANDARD = gnu17; GCC_NO_COMMON_BLOCKS = YES; GCC_OPTIMIZATION_LEVEL = 0; MACOSX_DEPLOYMENT_TARGET = 26.0; SDKROOT = macosx; SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG; SWIFT_VERSION = 6.0; }; name = Debug; };
\t\tA001000000000000000000D1 /* Release */ = {isa = XCBuildConfiguration; buildSettings = {ALWAYS_SEARCH_USER_PATHS = NO; CLANG_ANALYZER_NONNULL = YES; CLANG_ENABLE_MODULES = YES; CLANG_ENABLE_OBJC_ARC = YES; CLANG_WARN_DOCUMENTATION_COMMENTS = YES; CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES; CODE_SIGNING_ALLOWED = NO; COPY_PHASE_STRIP = NO; DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym"; ENABLE_NS_ASSERTIONS = NO; ENABLE_STRICT_OBJC_MSGSEND = YES; GCC_C_LANGUAGE_STANDARD = gnu17; GCC_NO_COMMON_BLOCKS = YES; MACOSX_DEPLOYMENT_TARGET = 26.0; SDKROOT = macosx; SWIFT_COMPILATION_MODE = wholemodule; SWIFT_VERSION = 6.0; }; name = Release; };
\t\tA001000000000000000000D2 /* Debug */ = {isa = XCBuildConfiguration; buildSettings = {CODE_SIGN_ENTITLEMENTS = Resources/FlowDesign.entitlements; CODE_SIGN_STYLE = Automatic; CODE_SIGNING_ALLOWED = NO; INFOPLIST_FILE = Resources/Info.plist; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/../Frameworks", ); PRODUCT_BUNDLE_IDENTIFIER = com.paulmarshall.FlowDesign; PRODUCT_NAME = FlowDesign; SWIFT_VERSION = 6.0; }; name = Debug; };
\t\tA001000000000000000000D3 /* Release */ = {isa = XCBuildConfiguration; buildSettings = {CODE_SIGN_ENTITLEMENTS = Resources/FlowDesign.entitlements; CODE_SIGN_STYLE = Automatic; CODE_SIGNING_ALLOWED = NO; INFOPLIST_FILE = Resources/Info.plist; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/../Frameworks", ); PRODUCT_BUNDLE_IDENTIFIER = com.paulmarshall.FlowDesign; PRODUCT_NAME = FlowDesign; SWIFT_VERSION = 6.0; }; name = Release; };
\t\tA001000000000000000000D4 /* Debug */ = {isa = XCBuildConfiguration; buildSettings = {CODE_SIGN_STYLE = Automatic; CODE_SIGNING_ALLOWED = NO; DEFINES_MODULE = YES; GENERATE_INFOPLIST_FILE = YES; PRODUCT_BUNDLE_IDENTIFIER = com.paulmarshall.FlowDesign.Core; PRODUCT_NAME = FlowDesignCore; SKIP_INSTALL = YES; SWIFT_VERSION = 6.0; }; name = Debug; };
\t\tA001000000000000000000D5 /* Release */ = {isa = XCBuildConfiguration; buildSettings = {CODE_SIGN_STYLE = Automatic; CODE_SIGNING_ALLOWED = NO; DEFINES_MODULE = YES; GENERATE_INFOPLIST_FILE = YES; PRODUCT_BUNDLE_IDENTIFIER = com.paulmarshall.FlowDesign.Core; PRODUCT_NAME = FlowDesignCore; SKIP_INSTALL = YES; SWIFT_VERSION = 6.0; }; name = Release; };
\t\tA001000000000000000000D6 /* Debug */ = {isa = XCBuildConfiguration; buildSettings = {CODE_SIGN_STYLE = Automatic; CODE_SIGNING_ALLOWED = NO; DEFINES_MODULE = YES; GENERATE_INFOPLIST_FILE = YES; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@loader_path/Frameworks", "@executable_path/../Frameworks", ); PRODUCT_BUNDLE_IDENTIFIER = com.paulmarshall.FlowDesign.PaperKit; PRODUCT_NAME = FlowDesignPaperKit; SKIP_INSTALL = YES; SWIFT_VERSION = 6.0; }; name = Debug; };
\t\tA001000000000000000000D7 /* Release */ = {isa = XCBuildConfiguration; buildSettings = {CODE_SIGN_STYLE = Automatic; CODE_SIGNING_ALLOWED = NO; DEFINES_MODULE = YES; GENERATE_INFOPLIST_FILE = YES; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@loader_path/Frameworks", "@executable_path/../Frameworks", ); PRODUCT_BUNDLE_IDENTIFIER = com.paulmarshall.FlowDesign.PaperKit; PRODUCT_NAME = FlowDesignPaperKit; SKIP_INSTALL = YES; SWIFT_VERSION = 6.0; }; name = Release; };
\t\tA001000000000000000000D8 /* Debug */ = {isa = XCBuildConfiguration; buildSettings = {BUNDLE_LOADER = ""; CODE_SIGNING_ALLOWED = NO; GENERATE_INFOPLIST_FILE = YES; PRODUCT_BUNDLE_IDENTIFIER = com.paulmarshall.FlowDesign.CoreTests; PRODUCT_NAME = "$(TARGET_NAME)"; SWIFT_VERSION = 6.0; TEST_HOST = ""; }; name = Debug; };
\t\tA001000000000000000000D9 /* Release */ = {isa = XCBuildConfiguration; buildSettings = {BUNDLE_LOADER = ""; CODE_SIGNING_ALLOWED = NO; GENERATE_INFOPLIST_FILE = YES; PRODUCT_BUNDLE_IDENTIFIER = com.paulmarshall.FlowDesign.CoreTests; PRODUCT_NAME = "$(TARGET_NAME)"; SWIFT_VERSION = 6.0; TEST_HOST = ""; }; name = Release; };
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\tA001000000000000000000B0 /* Build configuration list for PBXNativeTarget "FlowDesign" */ = {isa = XCConfigurationList; buildConfigurations = (A001000000000000000000D2 /* Debug */, A001000000000000000000D3 /* Release */, ); defaultConfigurationIsVisible = 0; defaultConfigurationName = Debug; };
\t\tA001000000000000000000B1 /* Build configuration list for PBXNativeTarget "FlowDesignCore" */ = {isa = XCConfigurationList; buildConfigurations = (A001000000000000000000D4 /* Debug */, A001000000000000000000D5 /* Release */, ); defaultConfigurationIsVisible = 0; defaultConfigurationName = Debug; };
\t\tA001000000000000000000B2 /* Build configuration list for PBXNativeTarget "FlowDesignPaperKit" */ = {isa = XCConfigurationList; buildConfigurations = (A001000000000000000000D6 /* Debug */, A001000000000000000000D7 /* Release */, ); defaultConfigurationIsVisible = 0; defaultConfigurationName = Debug; };
\t\tA001000000000000000000B3 /* Build configuration list for PBXNativeTarget "FlowDesignCoreTests" */ = {isa = XCConfigurationList; buildConfigurations = (A001000000000000000000D8 /* Debug */, A001000000000000000000D9 /* Release */, ); defaultConfigurationIsVisible = 0; defaultConfigurationName = Debug; };
\t\tA001000000000000000000B4 /* Build configuration list for PBXProject "FlowDesign" */ = {isa = XCConfigurationList; buildConfigurations = (A001000000000000000000D0 /* Debug */, A001000000000000000000D1 /* Release */, ); defaultConfigurationIsVisible = 0; defaultConfigurationName = Debug; };
/* End XCConfigurationList section */
\t};
\trootObject = A00100000000000000000060 /* Project object */;
}
"""


SCHEME = """<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "2650"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "A00100000000000000000070"
               BuildableName = "FlowDesign.app"
               BlueprintName = "FlowDesign"
               ReferencedContainer = "container:FlowDesign.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES"
      shouldAutocreateTestPlan = "YES">
      <Testables>
         <TestableReference
            skipped = "NO">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "A00100000000000000000073"
               BuildableName = "FlowDesignCoreTests.xctest"
               BlueprintName = "FlowDesignCoreTests"
               ReferencedContainer = "container:FlowDesign.xcodeproj">
            </BuildableReference>
         </TestableReference>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "A00100000000000000000070"
            BuildableName = "FlowDesign.app"
            BlueprintName = "FlowDesign"
            ReferencedContainer = "container:FlowDesign.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "A00100000000000000000070"
            BuildableName = "FlowDesign.app"
            BlueprintName = "FlowDesign"
            ReferencedContainer = "container:FlowDesign.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
"""


def write_if_changed(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and path.read_text() == content:
        return
    path.write_text(content)


def main() -> None:
    write_if_changed(PROJECT_DIR / "project.pbxproj", PROJECT_PBXPROJ)
    write_if_changed(SCHEME_DIR / "FlowDesign.xcscheme", SCHEME)
    print(f"Generated {PROJECT_DIR.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
