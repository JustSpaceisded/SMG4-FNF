package;

import sys.FileSystem;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import haxe.io.Path; //This Could Be Potentionally Unstable, Keep An Eye Out -Generalisk

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		['The BF SMG4 Mod Team'], //TODO: Fix The Faulty HTML Redirect
		['Cometflamer', 'Cometflamer', 'The Creator Of The If Boyfriend Was In SMG4 Mod, The Creator Of The Mods Twitter Account & Discord Server', 'https://twitter.com/cometflamer', 0xFFF7B63B],
		['Programmers'],
		['Generalisk', 'Generalisk', 'Lead Programmer/SFM Animator For The Trailer\'s And The One Writing These Peices Of Text RN', 'https://www.youtube.com/channel/UCS7UTEe7YAozWVJS5gCaohQ', 0xFFFF0000],
		['Yelly', 'Yelly', 'Programmer', 'https://twitter.com/YellyTheDuck', 0xFFFFFF42],
		['Gazozoz', 'Gazozoz', 'Programmer', 'https://twitter.com/Gazozoz_', 0xFF204BA1],
		['Artists'],
		['Swirl Golem', 'SwirlGolem', 'Artist/Animator', 'https://twitter.com/swirl_golem', 0xFFFFFFFF],
		['Yume Potato', 'Yume', 'Artist/Animator', 'https://twitter.com/ComaYamiYume', 0xFF222222],
		['Wix', 'Wix', 'Artist', 'https://twitter.com/freedom04260270', 0xFF6B6228],
		['Phanta', 'Phanta', 'Artist', 'https://twitter.com/PhantaBlueberry', 0xFF3B858C],
		['Porsche', 'Porsche', 'Animator', 'https://twitter.com/phuphasin', 0xFF03FC4E],
		['Composers'],
		['Hipstery Dibstery', 'HipsteryDibstery', 'Composer And Creator Of Funkin Unknown', 'https://twitter.com/funkinunknown', 0xFFFF0000],
		['Smecho Geck', 'SmeckoGeck', 'Composer And Creator Of A Few UTAUs We Used (Am I Allowed To Tell Them That? No? Well, Screw You, I\'m Keeping This Anyway)', 'https://www.youtube.com/channel/UC4n1MBx844Fr6lFGwoqjeaw', 0xFF00FF15],
		['Dee Dae', 'DeeDae', 'Composer', 'https://twitter.com/Dee__Dae', 0xFF009402],
		['Unknown634', 'Unknown-New', 'Composer', 'https://youtube.com/channel/UCU5tGqEtuLJCF_UazGqvaPg', 0xFF53007D],
		['JumpinJellyFish', 'JumpinJellyFish', 'Composer', Sys.executablePath().replace("c\\", "C:\\") + '/assets/UnknownLink.html', 0xFFDDE36F], //Need Social Media Link
		['The Sad Cup', 'SadCup', 'Ex-Composer (He Left The Team, Rip)', Sys.executablePath().replace("c\\", "C:\\") + '/assets/UnknownLink.html', 0xFF9900FF], //Need Social Media Link
		['Syndocrite', 'Syndocrite', 'Composer', 'https://twitter.com/syndrocrite', 0xFF2B004F],
		['Charters'],
		['Nurf', 'Nurf', 'Charter', 'https://twitter.com/PeculiarNurf', 0xFFFFFFFF],
		['MistyFromHeaven', 'Misty', 'Charter', 'https://twitter.com/MistyOverHeaven', 0xFF8C3D00],
		['TheSlithyGamer4Evr', 'Slithy', 'Charter', 'https://www.youtube.com/channel/UCRyEPq3297h56-cubR38TGA', 0xFFA18E7F],
		['Dat1awkwardboi', 'AwkwardBoi', 'Charter', 'https://youtube.com/channel/UCSApVnFslu9WnUTFE1Wdi8A', 0xFFC800FF],
		['Voice Actors'],
		['TJackKnife', 'TJack', 'Voice Of SMG4', 'https://twitter.com/JaredBehning', 0xFF7B00FF],
		['CozyDough', 'CozyDough', 'Voice Of [REDACTED, for now]', 'https://www.youtube.com/channel/UCxoN8Hd3p72wEltGGlXoRBw', 0xFF0000FF],
		['Redenvi', 'Rendevi', 'Voice Of [REDACTED, for now]', 'https://twitter.com/Doc_Glowstick', 0xFFFF006A],
		['Joeseph Joestar', 'Joseph', 'Voice Of [REDACTED, for now]', 'https://twitter.com/Term7Studios?t=YzuXUmHqfQuLqDWRqkqBwQ&s=09', 0xFF46247D],
		['Special Thanks'],
		['Classic Ink Studios', 'CEO', 'Mario 64 And Gmod Animator', 'https://www.youtube.com/channel/UCkp0MC3pwipYx7znGwZ7WTA', 0xFF4B2769],
		['Our Socials'],
		['YouTube', 'YouTube', 'Trailer\'s, Teaser\'s & More', 'https://www.youtube.com/channel/UCH6mon1-ZhzBe976dk8tXsQ', 0xFFFF0000],
		['Twitter', 'Twitter', 'Teaser\'s, Update\'s & More', 'https://twitter.com/smg4fnf', 0xFF00ACEE],
		['Discord Community Server', 'Discord', 'A Hangout For Fan\'s Of The Mod With Regular Meme\'s From The Dev\'s, "Leak\'s" & More', 'https://discord.gg/ABKCJZFmQw', 0xFF364169],
		['Github Source Code', 'GitHub', 'The Source Code For The Mod, Because ninjamuffin Say\'s We Have To', 'https://github.com/Generalisk/SMG4-FNF', 0xFF171515] //Presumably The Link, No Public Link At Time Of Me Typing This -Generalisk
	];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menu", null, "title-card");
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);

				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("smg.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
