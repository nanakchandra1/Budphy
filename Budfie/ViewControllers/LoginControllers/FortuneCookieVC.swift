//
//  FortuneCookieVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 10/04/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON
import UIKit

class FortuneCookieVC: BaseVc {

    /*
     let fortunes: Set<String> = [
     "A dream you have will come true.",
     "Today is the day for Fresh beginnings",
     "Never give up. You're not a failure if you don't give up.",
     "You will become great if you believe in yourself.",
     " A smile shall bring you luck today",
     "You will marry your lover.",
     "A very attractive person has a message for you. ",
     "You already know the answer to the questions lingering inside your head.",
     "People look upto you.",
     "You can make your own happiness.",
     "The greatest risk is not taking one.",
     "The love of your life is stepping into your planet this summer.",
     "Serious trouble will bypass you.",
     "A short stranger will soon enter your life with blessings to share.",
     "Now is the time to try something new.",
     "Wealth awaits you very soon.",
     "Keep your eye out for someone special.",
     "You are very talented in many ways.",
     "A new voyage will fill your life with untold memories.",
     "You will travel to many exotic places in your lifetime.",
     "Your ability for accomplishment will follow with success.",
     "A friend asks only for your time not your money.",
     "A smile is your passport into the hearts of others.",
     "Your high-minded principles spell success.",
     "Change can hurt, but it leads a path to something better.",
     "Enjoy the good luck a companion brings you.",
     "People are naturally attracted to you.",
     "A chance meeting opens new doors to success and friendship.",
     "You learn from your mistakes… You will learn a lot today.",
     "If you have something good in your life, don't let it go!",
     "You cannot love life until you live the life you love.",
     "Everyone agrees. You are the best.",
     "LIFE CONSIST NOT IN HOLDING GOOD CARDS, BUT IN PLAYING THOSE YOU HOLD WELL.",
     "Jealousy doesn't open doors, it closes them!",
     "It's better to be alone sometimes.",
     "When fear hurts you, conquer it and defeat it!",
     "When fear hurts you, conquer it and defeat it!",
     "You will conquer obstacles to achieve success.",
     "Joys are often the shadows, cast by sorrows.",
     "Fortune favors the brave.",
     "Never give up. Always find a reason to keep trying.",
     "If you have something worth fighting for, then fight for it.",
     "Stop wishing. Start doing.",
     "Stay true to those who would do the same for you.",
     "Help is always needed but not always appreciated.",
     "Hone your competitive instincts.",
     "Finish your work on hand don't be greedy.",
     "Your fortune is as sweet as a cookie.",
     "If you're happy, you're successful.",
     "You will always be surrounded by true friends",
     "Before trying to please others think of what makes you happy.",
     "Your golden opportunity is coming shortly.",
     "For hate is never conquered by hate. Hate is conquered by love.",
     "You cannot become rich except by enriching others.",
     "Don't pursue happiness - create it.",
     "You will be successful in love.",
     "All your fingers can't be of the same length.",
     "A lifetime of happiness is in store for you.",
     "It is very possible that you will achieve greatness in your lifetime.",
     "You are the controller of your destiny.",
     "Everything happens for a reason.",
     "How can you have a beutiful ending without making beautiful mistakes.",
     "You can open doors with your charm and patience.",
     "Welcome the change coming into your life."]
     */

    /*
    let fortunes: Set<String> = [
        "A dream you have will come true.",
        "Today is the day for Fresh beginnings",
        " A smile shall bring you luck today",
        "You will marry your lover.",
        "People look upto you.",
        "You can make your own happiness.",
        "The greatest risk is not taking one.",
        "Serious trouble will bypass you.",
        "Now is the time to try something new.",
        "Wealth awaits you very soon.",
        "Keep your eye out for someone special.",
        "You are very talented in many ways.",
        "Your high-minded principles spell success.",
        "Enjoy the good luck a companion brings you.",
        "People are naturally attracted to you.",
        "Everyone agrees. You are the best.",
        "Jealousy doesn't open doors, it closes them!",
        "It's better to be alone sometimes.",
        "When fear hurts you, conquer it and defeat it!",
        "When fear hurts you, conquer it and defeat it!",
        "You will conquer obstacles to achieve success.",
        "Joys are often the shadows, cast by sorrows.",
        "Fortune favors the brave.",
        "Never give up. Always find a reason to keep trying.",
        "Stop wishing. Start doing.",
        "Stay true to those who would do the same for you.",
        "Help is always needed but not always appreciated.",
        "Hone your competitive instincts.",
        "Finish your work on hand don't be greedy.",
        "Your fortune is as sweet as a cookie.",
        "If you're happy, you're successful.",
        "You will always be surrounded by true friends",
        "Your golden opportunity is coming shortly.",
        "You cannot become rich except by enriching others.",
        "Don't pursue happiness - create it.",
        "You will be successful in love.",
        "All your fingers can't be of the same length.",
        "A lifetime of happiness is in store for you.",
        "You are the controller of your destiny.",
        "Everything happens for a reason.",
        "You can open doors with your charm and patience.",
        "Welcome the change coming into your life."]
    */

    let fortunes: Set<String> = [
        "You will marry your lover.",
        "People look upto you.",
        "You are very talented in many ways.",
        "People are naturally attracted to you.",
        "Everyone agrees. You are the best.",
        "It's better to be alone sometimes.",
        "Fortune favors the brave.",
        "Stop wishing. Start doing.",
        "Your fortune is as sweet as a cookie.",
        "If you're happy, you're successful.",
        "Don't pursue happiness - create it.",
        "You will be successful in love.",
        "You are the controller of your destiny.",
        "Everything happens for a reason."]

    var usedFortunes  : Set<String> = []
    var unusedFortunes: Set<String> = []

    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var status: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var fortuneLbl: UILabel!
    @IBOutlet weak var fortuneHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var fortuneVerticalConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let fortune = getTodaysFortune() {
            fortuneLbl.text = fortune
        } else {
            getUnsedFortunes()
            getRandomFortune()
        }

        if screenHeight > 800 {
            fortuneVerticalConstraint.constant = 50
            fortuneHorizontalConstraint.constant = 2
            fortuneLbl.preferredMaxLayoutWidth = 180
            backgroundImageView.image = #imageLiteral(resourceName: "cookie_iphoneX")
        } else {
            fortuneLbl.preferredMaxLayoutWidth = 180
        }

        status.backgroundColor = AppColors.themeBlueColor
        navigationView.backgroundColor = UIColor.clear
        fortuneLbl.transform = CGAffineTransform(rotationAngle: 319.toRadians)
    }

    private func getTodaysFortune() -> String? {

        let calendar = Calendar.current
        let currentDate = Date()
        let startOfCurrentDate = calendar.startOfDay(for: currentDate)
        let fortuneExpiryJSON = AppUserDefaults.value(forKey: .fortuneExpiry)

        if fortuneExpiryJSON == JSON.null {

        } else if fortuneExpiryJSON.doubleValue > startOfCurrentDate.timeIntervalSince1970 {

            let fortuneJSON = AppUserDefaults.value(forKey: .fortune)

            if fortuneJSON == JSON.null {

            } else {

                let fortune = fortuneJSON.stringValue

                if !fortune.isEmpty {
                    return fortune
                }
            }
        }
        return nil
    }

    private func getUnsedFortunes() {

        let usedFortunesJSON = AppUserDefaults.value(forKey: .usedFortunes)

        if usedFortunesJSON == JSON.null {
            unusedFortunes = fortunes
        } else {

            let array = usedFortunesJSON.arrayValue

            for fortuneJSON in array {
                let fortuneString = fortuneJSON.stringValue
                if !fortuneString.isEmpty {
                    usedFortunes.insert(fortuneString)
                }
            }
            unusedFortunes = fortunes.subtracting(usedFortunes)
        }
    }

    private func getRandomFortune() {
        guard let fortune = unusedFortunes.randomElement else {
            return
        }
        fortuneLbl.text = fortune
        usedFortunes.insert(fortune)
        unusedFortunes.remove(fortune)
        saveFortuneInfo(fortune)
    }

    private func saveFortuneInfo(_ fortune: String) {

        let usedFortunesArray = Array(usedFortunes)
        AppUserDefaults.save(value: usedFortunesArray, forKey: .usedFortunes)

        AppUserDefaults.save(value: fortune, forKey: .fortune)

        let calendar = Calendar.current
        let currentDate = Date()
        let startOfCurrentDate = calendar.startOfDay(for: currentDate)

        if let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfCurrentDate) {
            let startOfNextDate = calendar.startOfDay(for: nextDate)
            AppUserDefaults.save(value: startOfNextDate.timeIntervalSince1970, forKey: .fortuneExpiry)
        }
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        pop()
    }
}

extension Set {
    var randomElement: Element? {
        let n = Int(arc4random_uniform(UInt32(self.count)))
        let index = self.index(self.startIndex, offsetBy: n)
        return self.count > 0 ? self[index] : nil
    }
}
