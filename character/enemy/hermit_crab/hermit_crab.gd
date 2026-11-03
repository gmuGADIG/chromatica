## Extends

## PSEUDOCODE

## states: IDLE, CHASE, ATTACK, HIDE
## flag: attack_from_shell = false

## IDLE:
##     patrol
##     if can_see_player → CHASE

## CHASE:
##     if lost sight for lose_sight_time → IDLE
##     if player in attack_range → ATTACK
##     else walk toward player

## on health_changed while in CHASE → ATTACK

## ATTACK (windup → active → recovery, one timer):
##     on entry: face the player
##     windup over → attack(): turn on attack hurtbox, lunge forward
##     active over → turn off hurtbox
##     recovery over:
##         if attack_from_shell:
##             attack_from_shell = false
##             → CHASE if can_see_player else IDLE
##         else → HIDE

## HIDE:
##     on entry: hitbox becomes un-hittable (optional)
##     stand still, count down hide_time
##     when it reaches 0: leave shell, attack_from_shell = true → ATTACK
