//
//  CandidateManager.swift
//  Food Dictator
//
//  Created by Mat Davidson on 5/9/16.
//  Copyright © 2016 Mat Davidson. All rights reserved.
//

import Foundation

class CandidateManager: NSObject {
    
    private var _candidates: [Candidate] = []

    override init() {
        
        super.init()

        // Note: can block initialization
        restore()
    }
    
    
    // MARK: - Persistence
    
    func cachePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0];
        let candidatesPlist = documentsDirectory + "/" + Constants.fdPersistanceFile
        return candidatesPlist
    }
    
    func save() {
        let wrapperArray = _candidates.map { $0.dataDictionary }
        let data = NSKeyedArchiver.archivedDataWithRootObject(wrapperArray)
        data.writeToFile(cachePath(), atomically: false)
    }
    
    func restore() {
        if let data = NSData.init(contentsOfFile: cachePath()) {
            let unwrapperArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [[String: AnyObject]]
            _candidates = unwrapperArray.map { Candidate.init(dataDictionary: $0) }
        }
        
        sortCandidates()
    }
    
    func sortCandidates() {
        _candidates.sortInPlace { (one, two) -> Bool in
            return one.name < two.name
        }
    }
    
    
    // MARK: - Access
    
    func candidates() -> [Candidate] {
        return _candidates
    }
    
    func toggleCandidateActivation(candidate: Candidate) {
        
        if let idx = _candidates.indexOf(candidate) {
            // modify in place to be sure we change the actual value and not a copy of the user struct
            if (_candidates[idx].isElectable) {
                _candidates[idx].isElectable = false
            }
            else {
                _candidates[idx].isElectable = true
            }

            save()
        }
    }
    
    func addUser(candidate: Candidate) {
        
        if let idx = _candidates.indexOf(candidate) {
            fatalError("candidate exists at index \(idx)")
        }
        
        _candidates.append(candidate)
        
        save()
        sortCandidates()
    }
    
    func removeCandidate(candidate: Candidate) {

        if let idx = _candidates.indexOf(candidate) {
            removeCandidateAtIndex(idx)
        }
        else {
            fatalError("candidate is not a current user")
        }
    }
    
    func removeCandidateAtIndex(index: Int) {
        _candidates.removeAtIndex(index)

        save()
    }
    
    func hasAvailableCandidates() -> Bool {
        let filtered = _candidates.filter { return $0.isElectable }
        return filtered.count != 0
    }
    
    // MARK: - Randomization
    
    func randomCandidate() -> Candidate {
        let availableCandidates = _candidates.filter { return $0.isElectable }
        let idx = arc4random_uniform( UInt32(availableCandidates.count) )
        return availableCandidates[Int(idx)]
    }
    
    func randomCandidateTitle() -> String {
        
        let titles = [
            "The King of Curry",
            "The Sultan of Burritostan",
            "Tin Pot of the Hot Pot",
            "The Indian Iron Fist",
            "El Presidente del Salsa",
            "The Sheik of Buffetistan",
            "Der Burgermeister",
            "Der Schniztel Fuhrer",
            "The Chief of Meat",
            "NO SOUP FOR YOU!",
            "The Taco Tyrant",
            "The Pasta Professor",
            "The Slurping Usurper",
            "The Hot Pot Despot",
            "The Tyrant of Taconia",
            "The Falafel Pharoah",
            "The Omakase Oligarch",
            "The Salad Bar Czar",
            "The Curry Consecrator",
            "The Munchie Mandator",
            "The DoorDash Warlord",
            "Lord of The Cheeseboard",
            "The Scourge of Soba",
            "aka Ghengis Flan",
            "aka Muammar GadImHungry",
            "aka Mao IZeHotDogs",
            "aka Chaing Kain-YouGetTheCheck",
            "aka Bashar al-SaladBar",
            "aka Sushi Mussolini"
        ]
     
        return titles[Int(arc4random_uniform( UInt32(titles.count) ))]
    }
    
    func randomCandidateQuote() -> String {
        
        let quotes = [
            "”Make the schnitzel big, make it simple, keep hammering it, and eventually they will eat it“\n– Adolf Hitler",
            "”Fullness is the solution to all problems. No borscht – no problem.”\n– Joseph Stalin",
            "”You cannot run faster than DoorDash delivery.”\n– Idi Amin",
            "”There is no state with better couscous than Libya on the whole planet.”\n– Moammar Gadhafi",
            "”Dieting is when you say you are going to eat one thing while intending to eat another. Then you eat neither what you said nor what you intended.”\n– Saddam Hussein",
            "”Veganism is war without bloodshed while war is veganism with bloodshed.”\n– Mao Zedong",
            "”We love curry. The U.S. loves burgers. That is the difference between us two.”\n– Osama bin Laden",
            "”The only WhiteCastle you can trust is a hot WhiteCastle.”\n– Robert Mugabe",
            "”Ideas are more powerful than Yelp reviews. We would not let our enemies have Yelp reviews, why should we let them have ideas.”\n– Josef Stalin",
            "”I don't care if they respect me so long as they fear my habenro peach salsa“ - Caligula",
            "”Let us have a steak between our teeth, a beer in our hands, and an infinite hunger in our hearts.”\n– Benito Mussolini",
            "”One man with a burrito can control 100 without one.”\n– Vladimir Lenin",
            "”The hungry peoples can liberate themselves only through struggle. This is a simple and clear truth confirmed by history.”\n– Kim Il-Sung",
            "”I'm not a dictator. It's just that I have a grumpy tummy.”\n– Augusto Pinochet",
            "”I use Tabasco for the many and reserve Sriracha for the few.”\n– Adolf Hitler",
            "”It's not for me. I've tried west coast IPAs and they're too hoppy for my taste.”\n– Idi Amin",
            "”A taco eaten often enough becomes the truth.”\n– Vladimir Lenin",
            "”Bad pizza joints are replaced only to have new pizza joints turn bad.”\n– Che Guevara",
            "”Never interrupt your enemy when he is making a souffle.”\n– Napoleon Bonaparte",
            "”My kimchi is the object of criticism around the world. But I think that since its being discussed, then I am on the right track.”\n– Kim Jong-Il",
            "”Conquering a super-burrito on horseback is easy; it is dismounting and digesting that is hard.”\n– Genghis Khan",
            "”I do not see why Vindaloo should not be just as cruel as nature.”\n– Adolf Hitler",
            "”One bad taco is a tragedy; one million is a statistic.”\n– Josef Stalin",
        ]
        
        return quotes[Int(arc4random_uniform( UInt32(quotes.count) ))]
    }

}





