

## PSEUDOCODE

## states: IDLE, CHASE, STUN

## IDLE:
##    patrol (walk back and forth, turn at walls/ledges)
##    if can_see_player → CHASE

## CHASE:
##    if can_see_player: reset lost-sight timer
##    else: add delta to lost-sight timer
##          if lost-sight timer >= lose_sight_time → IDLE
##    face the player and walk toward them at chase_speed (slow)
##    stop at walls and ledges

## STUN:
##    slide the knockback velocity to a stop
##    count down the timer
##    when it reaches 0 → CHASE if can_see_player else IDLE

##	on health_changed (from IDLE, CHASE or STUN):
##    knock back away from the player, then → STUN
##    (a hit during STUN restarts the stun)
