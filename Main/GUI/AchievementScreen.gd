extends Control

var achievement_idx = 0
var next_achievement = ACHIEVEMENTS[0]
const ACHIEVEMENTS = [500, 1000, 5000, 10000, 20000, 50000, 100000, 500000, 1000000, 10000000]

func update_player_distance(distance):
	if achievement_idx < ACHIEVEMENTS.size():
		if distance > next_achievement:
			$AchievementMessage.text = "%sm!!" % next_achievement
			$AnimationPlayer.play("ShowAndFade")
			achievement_idx+=1 
			if !$AudioStreamPlayer.playing:
				$AudioStreamPlayer.play()
			next_achievement = ACHIEVEMENTS[achievement_idx]
		
