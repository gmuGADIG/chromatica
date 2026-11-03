

## PSUEDOCODE

## states: IDLE, CHARGE, DECELERATE

## IDLE:
##     patrol
##     count down rest timer
##     if rest timer done AND can_see_player AND player is on ground → attack() (start charge)

## on health_changed while IDLE → attack() (even if it can't see the player)

## attack():
##     lock charge direction toward the player, face it → CHARGE

## CHARGE:
##     accelerate up to charge_speed in the locked direction
##     end the charge (→ DECELERATE) if:
##         - on floor AND (touching a wall OR at the end of the platform), OR
##         - within stop_distance of the player (ignored for the first min_charge_time)

## DECELERATE:
##     slow to a stop
##     when velocity reaches 0 → IDLE (starts the rest timer)
