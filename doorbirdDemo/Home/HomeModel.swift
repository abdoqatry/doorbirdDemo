//
//  HomeModel.swift
//  doorbirdDemo
//
//  Created by Admin on 26/01/2023.
//

import Foundation

// MARK: - NotificationModel
struct NotificationModel: Codable {
    let image: Image?
    let video: Video?
}

// MARK: - Image
struct Image: Codable {
    let url: String?
}

// MARK: - Video
struct Video: Codable {
    let cloud: Cloud?
    let local: Local?
}

// MARK: - Cloud
struct Cloud: Codable {
    let mjpg: Mjpg?
}

// MARK: - Mjpg
struct Mjpg: Codable {
    let mjpgDefault: Default?

    enum CodingKeys: String, CodingKey {
        case mjpgDefault = "default"
    }
}

// MARK: - Default
struct Default: Codable {
    let port: Int?
    let session, host, key: String?
}

// MARK: - Local
struct Local: Codable {
    let rtsp: RTSP?
}

// MARK: - RTSP
struct RTSP: Codable {
    let rtspDefault: Image?

    enum CodingKeys: String, CodingKey {
        case rtspDefault = "default"
    }
}
