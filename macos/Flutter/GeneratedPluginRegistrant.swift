//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import gal
import image_editor_common
import package_info_plus
import path_provider_foundation
import video_player_avfoundation
import wakelock_plus

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  GalPlugin.register(with: registry.registrar(forPlugin: "GalPlugin"))
  ImageEditorPlugin.register(with: registry.registrar(forPlugin: "ImageEditorPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  FVPVideoPlayerPlugin.register(with: registry.registrar(forPlugin: "FVPVideoPlayerPlugin"))
  WakelockPlusMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockPlusMacosPlugin"))
}
