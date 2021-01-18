--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        consumable = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        consumable = true,
        defaultState = 'unconsumed',
        states = {
            ['unconsumed'] = {
                frame = 5
            },
            ['consumed'] = {
                frame = 1
            }
        }        
    },
    ['pot'] = {
        type = 'pot',
        texture = 'pots',
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        consumable = false,
        pickable = true,
        defaultState = 'unbroken',
        travel = 0,
        states = {
            ['unbroken'] = {
                frame = 14
            },
            ['lifted'] = {
                frame = 34
            },
            ['projectile'] = {
                frame = 35
            },
            ['broken'] = {
                frame = 52
            },
            ['removed'] = {
                frame = 52
            }
        }        
    }
}