//
//  QuranBribesModel.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import UIKit
struct QuranBribesModel {
    
    func getPages(sora:Int)->[Int]{
        switch sora{
        case 1:
            return makePages(from: 0, to: 1)
        case 2:
            return makePages(from: 2, to: 49)
        case 3:
            return makePages(from: 50, to: 76)
        case 4:
            return makePages(from: 77, to: 106)
        case 5:
            return makePages(from: 106, to: 127)
        case 6:
            return makePages(from: 128, to: 150)
        case 7:
            return makePages(from: 151, to: 176)
        case 8:
            return makePages(from: 177, to: 186)
        case 9:
            return makePages(from: 187, to: 207)
        case 10:
            return makePages(from: 208, to: 221)
        case 11:
            return makePages(from: 221, to: 235)
        case 12:
            return makePages(from: 235, to: 248)
        case 13:
            return makePages(from: 249, to: 255)
        case 14:
            return makePages(from: 255, to: 261)
        case 15:
            return makePages(from: 262, to: 267)
        case 16:
            return makePages(from: 267, to: 281)
        case 17:
            return makePages(from: 282, to: 293)
        case 18:
            return makePages(from: 293, to: 304)
        case 19:
            return makePages(from: 305, to: 312)
        case 20:
            return makePages(from: 312, to: 321)
        case 21:
            return makePages(from: 322, to: 331)
        case 22:
            return makePages(from: 332, to: 341)
        case 23:
            return makePages(from: 342, to: 349)
        case 24:
            return makePages(from: 350, to: 359)
        case 25:
            return makePages(from: 359, to: 366)
        case 26:
            return makePages(from: 367, to: 376)
        case 27:
            return makePages(from: 377, to: 385)
        case 28:
            return makePages(from: 385, to: 396)
        case 29:
            return makePages(from: 396, to: 404)
        case 30:
            return makePages(from: 404, to: 410)
        case 31:
            return makePages(from: 401, to: 414)
        case 32:
            return makePages(from: 415, to: 417)
        case 33:
            return makePages(from: 418, to: 427)
        case 34:
            return makePages(from: 428, to: 434)
        case 35:
            return makePages(from: 434, to: 440)
        case 36:
            return makePages(from: 440, to: 445)
        case 37:
            return makePages(from: 446, to: 452)
        case 38:
            return makePages(from: 453, to: 458)
        case 39:
            return makePages(from: 458, to: 467)
        case 40:
            return makePages(from: 467, to: 476)
        case 41:
            return makePages(from: 477, to: 482)
        case 42:
            return makePages(from: 483, to: 489)
        case 43:
            return makePages(from: 489, to: 495)
        case 44:
            return makePages(from: 496, to: 498)
        case 45:
            return makePages(from: 499, to: 502)
        case 46:
            return makePages(from: 502, to: 506)
        case 47:
            return makePages(from: 507, to: 510)
        case 48:
            return makePages(from: 511, to: 515)
        case 49:
            return makePages(from: 515, to: 517)
        case 50:
            return makePages(from: 518, to: 520)
        case 51:
            return makePages(from: 520, to: 523)
        case 52:
            return makePages(from: 523, to: 525)
        case 53:
            return makePages(from: 526, to: 528)
        case 54:
            return makePages(from: 528, to: 531)
        case 55:
            return makePages(from: 531, to: 534)
        case 56:
            return makePages(from: 534, to: 537)
        case 57:
            return makePages(from: 537, to: 541)
        case 58:
            return makePages(from: 542, to: 545)
        case 59:
            return makePages(from: 545, to: 548)
        case 60:
            return makePages(from: 549, to: 551)
        case 61:
            return makePages(from: 551, to: 552)
        case 62:
            return makePages(from: 553, to: 554)
        case 63:
            return makePages(from: 554, to: 555)
        case 64:
            return makePages(from: 556, to: 557)
        case 65:
            return makePages(from: 558, to: 559)
        case 66:
            return makePages(from: 560, to: 561)
        case 67:
            return makePages(from: 562, to: 564)
        case 68:
            return makePages(from: 564, to: 566)
        case 69:
            return makePages(from: 566, to: 568)
        case 70:
            return makePages(from: 568, to: 570)
        case 71:
            return makePages(from: 570, to: 571)
        case 72:
            return makePages(from: 572, to: 573)
        case 73:
            return makePages(from: 574, to: 575)
        case 74:
            return makePages(from: 575, to: 577)
        case 75:
            return makePages(from: 577, to: 578)
        case 76:
            return makePages(from: 578, to: 580)
        case 77:
            return makePages(from: 580, to: 581)
        case 78:
            return makePages(from: 582, to: 583)
        case 79:
            return makePages(from: 583, to: 584)
        case 80:
            return makePages(from: 585, to: 586)
        case 81:
            return makePages(from: 586, to: 586)
        case 82:
            return makePages(from: 587, to: 587)
        case 83:
            return makePages(from: 587, to: 589)
        case 84:
            return makePages(from: 589, to: 590)
        case 85:
            return makePages(from: 590, to: 590)
        case 86:
            return makePages(from: 591, to: 591)
        case 87:
            return makePages(from: 591, to: 592)
        case 88:
            return makePages(from: 592, to: 593)
        case 89:
            return makePages(from: 593, to: 594)
        case 90:
            return makePages(from: 594, to: 595)
        case 91:
            return makePages(from: 595, to: 595)
        case 92:
            return makePages(from: 595, to: 596)
        case 93:
            return makePages(from: 596, to: 596)
        case 94:
            return makePages(from: 596, to: 596)
        case 95:
            return makePages(from: 597, to: 597)
        case 96:
            return makePages(from: 597, to: 597)
        case 97:
            return makePages(from: 598, to: 598)
        case 98:
            return makePages(from: 598, to: 599)
        case 99:
            return makePages(from: 599, to: 599)
        case 100:
            return makePages(from: 599, to: 600)
        case 101:
            return makePages(from: 600, to: 600)
        case 102:
            return makePages(from: 600, to: 600)
        case 103:
            return makePages(from: 601, to: 601)
        case 104:
            return makePages(from: 601, to: 601)
        case 105:
            return makePages(from: 601, to: 601)
        case 106:
            return makePages(from: 602, to: 602)
        case 107:
            return makePages(from: 602, to: 602)
        case 108:
            return makePages(from: 602, to: 602)
        case 109:
            return makePages(from: 603, to: 603)
        case 110:
            return makePages(from: 603, to: 603)
        case 111:
            return makePages(from: 603, to: 603)
        case 112:
            return makePages(from: 604, to: 604)
        case 113:
            return makePages(from: 604, to: 604)
        case 114:
            return makePages(from: 604, to: 604)
        default:
            print()
        }
        return []
    }
    
    private func makePages(from:Int, to:Int)->[Int]{
        var pages = [Int]()
        for i in from...to{
            if i != 0{
                pages.append(i)
            }
        }
        return pages
    }
}

struct QuranModel: Codable {
    var sora: Int
    let soraName: String
    let page: Int
}
