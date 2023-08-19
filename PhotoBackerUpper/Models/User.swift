//
//  User.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 17/08/2023.
//

import Foundation

class User:Codable {
    var id: String?
    var email: String?
    var password: String?
    var username: String?
    var token: String?
    var admin: Bool?
    var time_stamp_utc: String?
    var user_directories: [Directory]?
    
}

class Directory:Codable {
    var id: String
    var display_name: String
    var display_name_no_spaces: String
    var public_status: Bool?
    var member: Bool?
    var permission_view: Bool?
    var permission_delete: Bool?
    var permission_add_to_dir: Bool?
    var permission_admin: Bool?
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DirectoryCodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        display_name = try container.decode(String.self, forKey: .display_name)
        display_name_no_spaces = try container.decode(String.self, forKey: .display_name_no_spaces)
        public_status = try container.decodeIfPresent(Bool.self, forKey: .public_status)
        
        member = try container.decodeIfPresent(Bool.self, forKey: .member) ?? false
        
        permission_view = try container.decodeIfPresent(Bool.self, forKey: .permission_view) ?? true
        permission_delete = try container.decodeIfPresent(Bool.self, forKey: .permission_delete) ?? false
        permission_add_to_dir = try container.decodeIfPresent(Bool.self, forKey: .permission_add_to_dir) ?? false
//        permission_post = try container.decodeIfPresent(Bool.self, forKey: .permission_post) ?? false
        permission_admin = try container.decodeIfPresent(Bool.self, forKey: .permission_admin) ?? false
    }
    
    init(id: String, display_name: String, display_name_no_spaces: String) {
        self.id = id
        self.display_name = display_name
        self.display_name_no_spaces = display_name_no_spaces
        self.permission_view = false
    }
    
    private enum DirectoryCodingKeys: String, CodingKey {
        case id, display_name, display_name_no_spaces, public_status, member, permission_view, permission_delete, permission_add_to_dir,  permission_admin
    }
    
}
