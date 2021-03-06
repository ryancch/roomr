//
//  UserFilterP2.swift
//  Roomr
//
//  Created by Katie Kwak on 12/1/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import Foundation
import CSV

func checkHousingCompatibility(user1: ProfileSummary, user2: ProfileSummary) -> Bool {
    /*housingPref: 1 means need apartment
                   2 means need roommate
                   3 means both */
    // return true when one has what the other wants (vice versa)
    switch (user1.housing_preference, user2.housing_preference) {
    case (1,1): // both need apts X
        return false
    case (1,2): // 1 needs apt and 2 has apt
        return true
    case (1,3): // 1 only needs apt (no rmmate) but 2 needs both
        return false
    case (2,1): // 1 needs rmmate and 2 needs apt
        return true
    case (2,2): // both need rmmates, already have their own apt
        return false
    case (2,3):  // 1 needs rmmate & has apt, 2 needs rmmt & apt
        return true
    case (3,1): // same as case (1,3)
        return false
    case (3,2): // same as case (2,3)
        return true
    case (3,3): // both are in need of rmmates but neither have apt
        return false
    default:
        return false
    }
} /* checkHousingCompatibility() */




func checkGenderCompatibility(user1: ProfileSummary, user2: ProfileSummary) -> Bool {
    // return true only if both users' genders match each other's preferences
    var result = false
    switch (user1.gender_preference, user2.user_gender) {
    case ("Women", "Man"):
        return false
    case ("Women", "Woman"):
        result = true
    case ("Men", "Man"):
        result = true
    case ("Men", "Woman"):
        return false
    case ("Everyone", "Man"):
        result = true
    case ("Everyone", "Woman"):
        result = true
    default:
        return false
    }
    
    // now check other way
    switch (user2.gender_preference, user1.user_gender) {
        case ("Women", "Man"):
            return false
        case ("Women", "Woman"):
            result = true
        case ("Men", "Man"):
            result = true
        case ("Men", "Woman"):
            return false
        case ("Everyone", "Man"):
            result = true
        case ("Everyone", "Woman"):
            result = true
        default:
            return false
    }
    
    return result
} /* checkGenderCompatibility() */




func checkCleanCompatibility(user1: ProfileSummary, user2: ProfileSummary) -> Bool {
    // return true if #2's cleanliness falls within range [dirtiest - cleanest]
    // unwrap:
    guard let clean1 = user1.cleanliness, let clean2 = user2.cleanliness else { return false }
    
    // calculate dirtiest level target user can withstand (3 tiers below their cleanliness)
    var dirtiest = 1
    if (clean1 >= 3) {
        dirtiest = clean1 - 3
    }
    
    // check if user 2 falls within cleanliness user 1 can withstand
    let cleanest = 10
    if dirtiest ... cleanest ~= clean2 {
        return true // falls within range
    } else {
        return false
    }
} /* checkCleanCompatibility() */




func checkVolumeCompatibility(user1: ProfileSummary, user2: ProfileSummary) -> Bool {
    // return true if #2's volume is quiet enough for target user
    // unwrap:
    guard let volume1 = user1.volume, let volume2 = user2.volume else { return false }
    
    // calculate the loudest target user can withstand (2 tiers above their loudness)
    var loudest = 10
    if (volume1 < 8) {
        loudest = volume1 + 2
    }
    
    // check if user 2 falls within loudness user 1 can withstand
    let quietest = 1
    if quietest ... loudest ~= volume2 {
        return true // falls within range
    } else {
        return false
    }
    
} /* checkVolumeCompatibility() */




func filterPreferenceMismatches(targetUser: ProfileSummary, user: ProfileSummary) -> Bool {
    // only add user if compatible with target user:
    if (targetUser.user_key == user.user_key) {
        return false  // skip if same person
    } else if (checkHousingCompatibility(user1: targetUser, user2: user) == false) {
        return false
    } else if (checkGenderCompatibility(user1: targetUser, user2: user) == false) {
        return false
    } else if (checkCleanCompatibility(user1: targetUser, user2: user) == false) {
        return false
    } else if (checkVolumeCompatibility(user1: targetUser, user2: user) == false) {
        return false
    // TODO: make sure they aren't in matched, liked or disliked candidates
    } else {
        return true
    }
} /* filterPreferenceMismatches(): remove incompatible users */




