Bacterriors
===========

Frontend is Elm
Backend is Go

+-------+
| r     |
|    t  |
| #     |
+-------+


## Rules

1. Player starts with a basic bacterrior randomly spawned on the field
1. Player gains experience by eating food on the field or by beating other bacterriors
1. Each food gives a player BEGR * 10 experience points
1. Each eaten bacterrior gives BEGR * 75% of its experience to the player
1. After reaching a level amount of experience goes to zero and the amount to reach next level increases
1. Each level gives player BDGR * 20 DNA points which can be used after round to improve their bacterriors by switching/upgrading/adding cells
1. When player doesn't gain experience for 30 seconds it starts degrading
1. Basic characteristics of bacterriors:
    - Movement speed - pink dot
    - Base size/mass coefficient - black dot
    - Base experience gain rate - yellow dot
    - Base DNA points gain rate - green dot
    - Base rate for evolution - violet dot
    - Vision radius - white dot
    - Visibility - blue dot (min 0.5)
1. When player dies, he can go to switching/upgrading/adding cells screen
1. When player respawns, he starts with his level and new characteristics, but of an initial size
1. Bacterriors types:
    - Basic (all rates are 1)
    - Black Hole (ms - 0.85, smc - 1.15, vis - 1.3)
    - Nerd (xp - 1.15, dna - 0.85)
    - Pusher (evo - 0.85, dna - 1.05, xp - 0.8)
    - Acid (dna - 1.15, xp - 0.85)
    - Invis (vis - 0.85, ms - 0.85, smc - 0.9)

## Techicalities

1. 1 frame - 1s/60 (60 fps)
1. WebSockets
1. Player can move his bacterrior around using mouse or touch the screen to change the direction
1. Depending on the distance from a bacterrior the velocity of its movement will increase or decrease, but always > 0
1. Randomly new food appears on the field

## MVP

### Stage I

1. Player and food
1. Minimal graphics to distinguish cells
1. One type of cells upgrade - movement speed - automaticaly after reaching a level
1. No animation of eating, simply remove from the screen
1. No touch control

### Stage II

1. Player, food and 1 NPC enemy
1. Randomly moving enemy with the same characteristics as the player's bacterrior
1. Improved graphics

### Stage III

1. Responsive image
1. Player, food, 1 enemy, second player
1. Touch control
1. Visibility and size/mass cells
1. Improved graphics

### Stage IV

1. Upgrade screens
1. Starting screen to pick a name for anonimous game/sign up
