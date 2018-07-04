// Training.asm (by Fray)
if !{defined __TRAINING__} {
define __TRAINING__()
if {defined __CE__} {

// @ Description
// This file contains functions and defines structs intended to assist training mode modifications.

include "Character.asm"
include "Global.asm"
include "Menu.asm"
include "OS.asm"

scope Training {
    // @ Description
    // Byte, determines whether the player is able to control the training mode menu, regardless of
    // if it is currently being displayed. 01 = disable control, 02 = enable control
    constant toggle_menu(0x80190979)
    
    // @ Description
    // Byte, contains the training mode stage id
    constant stage(0x80190969)
    
    // @ Description
    // Contains game settings, as well as information and properties for each port.
    // PORT STRUCT INFO
    // @ ID         [read/write]
    // Contains character ID, see character.asm for list.
    // @ type       [read/write]
    // 0x00 = MAN, 0x01 = COM, 0x02 = NOT
    // @ costume    [read/write]
    // Contains the costume ID.
    // @ percent    [read only]
    // Contains the current percentage.
    // Read only. Use Character.add_percent_ and Training.reset_percent_ to write.
    // @ spawn_id    [read/write]
    // Contains the player's spawn id.
    // 0x00 = port 1, 0x01 = port 2, 0x02 = port 3, 0x03 = port 4, 0x04 = custom
    // @ spawn_pos
    // Contains custom spawn position.
    // float32 xpos, float32 ypos
    // @ spawn_dir
    // Contains custom spawn direction.
    // 0xFFFFFFFF = left, 0x00000001 = right
    scope struct {
        scope main: {
            // @ Description
            // stage id, see stages.asm for list
            stage:
            dw OS.NULL
        }
        scope port_1: {
            ID:
            dw OS.NULL
            type:
            dw OS.NULL
            costume:
            dw OS.NULL
            percent:
            dw OS.NULL
            spawn_id:
            dw OS.NULL
            spawn_pos:
            float32 0,0
            spawn_dir:
            dw 0xFFFFFFFF
        }
        scope port_2: {
            ID:
            dw OS.NULL
            type:
            dw OS.NULL
            costume:
            dw OS.NULL
            percent:
            dw OS.NULL
            spawn_id:
            dw OS.NULL
            spawn_pos:
            float32 0,0
            spawn_dir:
            dw 0xFFFFFFFF
        }
        scope port_3: {
            ID:
            dw OS.NULL
            type:
            dw OS.NULL
            costume:
            dw OS.NULL
            percent:
            dw OS.NULL
            spawn_id:
            dw OS.NULL
            spawn_pos:
            float32 0,0
            spawn_dir:
            dw 0xFFFFFFFF
        }
        scope port_4: {
            ID:
            dw OS.NULL
            type:
            dw OS.NULL
            costume:
            dw OS.NULL
            percent:
            dw OS.NULL
            spawn_id:
            dw OS.NULL
            spawn_pos:
            float32 0,0
            spawn_dir:
            dw 0xFFFFFFFF
        }
        
        // @ Description
        // table of pointers to each port struct
        table:
        dw port_1
        dw port_2
        dw port_3
        dw port_4
    }

    // @ Description
    // This function loads various character properties when training mode is loaded
    scope load_character_: {
        OS.patch_start(0x00116AA0, 0x80190280)
        jal load_character_
        nop
        OS.patch_end()
        
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0004(sp)              // ~
        sw      t0, 0x0008(sp)              // ~
        sw      t1, 0x000C(sp)              // ~
        sw      t2, 0x0010(sp)              // ~
        sw      t3, 0x0014(sp)              // store ra, t0-t3
        
        li      t0, Global.match_info       // ~
        lw      t0, 0x0000(t0)              // t1 = match info address
        li      t1, reset_counter           // t1 = reset counter
        lw      t1, 0x0000(t1)              // t1 = reset counter value
        beq     t1, r0, _initialize_p1      // initialize values if load from sss is detected
        ori     t3, r0, Character.id.NONE   // t3 = character id: NONE
        
        _load_p1:
        addiu   t0, Global.vs.P_OFFSET      // t0 = p1 info
        li      t1, struct.port_1.ID        // ~
        lw      t1, 0x0000(t1)              // t1 = port 1 char id
        sb      t1, 0x0003(t0)              // store char id
        li      t1, struct.port_1.type      // ~
        lw      t1, 0x0000(t1)              // t1 = port 1 type
        sb      t1, 0x0002(t0)              // store type
        li      t1, struct.port_1.costume   // ~
        lw      t1, 0x0000(t1)              // t1 = port 1 costume
        sb      t1, 0x0006(t0)              // store costume
        _load_p2:
        addiu   t0, Global.vs.P_DIFF        // t0 = p2 info
        li      t1, struct.port_2.ID        // ~
        lw      t1, 0x0000(t1)              // t1 = port 2 char id
        sb      t1, 0x0003(t0)              // store char id
        li      t1, struct.port_2.type      // ~
        lw      t1, 0x0000(t1)              // t1 = port 2 type
        sb      t1, 0x0002(t0)              // store type
        li      t1, struct.port_2.costume   // ~
        lw      t1, 0x0000(t1)              // t1 = port 2 costume
        sb      t1, 0x0006(t0)              // store costume
        _load_p3:
        addiu   t0, Global.vs.P_DIFF        // t0 = p3 info
        li      t1, struct.port_3.ID        // ~
        lw      t1, 0x0000(t1)              // t1 = port 3 char id
        sb      t1, 0x0003(t0)              // store char id
        li      t1, struct.port_3.type      // ~
        lw      t1, 0x0000(t1)              // t1 = port 3 type
        sb      t1, 0x0002(t0)              // store type
        li      t1, struct.port_3.costume   // ~
        lw      t1, 0x0000(t1)              // t1 = port 3 costume
        sb      t1, 0x0006(t0)              // store costume
        _load_p4:
        addiu   t0, Global.vs.P_DIFF        // t0 = p4 info
        li      t1, struct.port_4.ID        // ~
        lw      t1, 0x0000(t1)              // t1 = port 4 char id
        sb      t1, 0x0003(t0)              // store char id
        li      t1, struct.port_4.type      // ~
        lw      t1, 0x0000(t1)              // t1 = port 4 type
        sb      t1, 0x0002(t0)              // store type
        li      t1, struct.port_4.costume   // ~
        lw      t1, 0x0000(t1)              // t1 = port 4 costume
        sb      t1, 0x0006(t0)              // store costume
        j       _end                        // jump to end
        nop
        
        _initialize_p1:
        addiu   t0, Global.vs.P_OFFSET      // t0 = p1 info
        lbu     t1, 0x0003(t0)              // t1 = char id
        li      t2, struct.port_1.ID        // t2 = struct id pointer
        bnel    t1, t3, _initialize_p1+0x18 // ~
        sw      t1, 0x0000(t2)              // if id != NONE, store in struct
        lbu     t1, 0x0002(t0)              // t1 = type
        li      t2, struct.port_1.type      // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store type in struct
        lbu     t1, 0x0006(t0)              // t1 = costume id
        li      t2, struct.port_1.costume   // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store costume id in struct
        _initialize_p2:
        addiu   t0, Global.vs.P_DIFF        // t0 = p2 info
        lbu     t1, 0x0003(t0)              // t1 = char id
        li      t2, struct.port_2.ID        // t2 = struct id pointer
        bnel    t1, t3, _initialize_p2+0x18 // ~
        sw      t1, 0x0000(t2)              // if id != NONE, store in struct
        lbu     t1, 0x0002(t0)              // t1 = type
        li      t2, struct.port_2.type      // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store type in struct
        lbu     t1, 0x0006(t0)              // t1 = costume id
        li      t2, struct.port_2.costume   // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store costume id in struct
        _initialize_p3:
        addiu   t0, Global.vs.P_DIFF        // t0 = p3 info
        lbu     t1, 0x0003(t0)              // t1 = char id
        li      t2, struct.port_3.ID        // t2 = struct id pointer
        bnel    t1, t3, _initialize_p3+0x18 // ~
        sw      t1, 0x0000(t2)              // if id != NONE, store in struct
        lbu     t1, 0x0002(t0)              // t1 = type
        li      t2, struct.port_3.type      // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store type in struct
        lbu     t1, 0x0006(t0)              // t1 = costume id
        li      t2, struct.port_3.costume   // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store costume id in struct
        _initialize_p4:
        addiu   t0, Global.vs.P_DIFF        // t0 = p4 info
        lbu     t1, 0x0003(t0)              // t1 = char id
        li      t2, struct.port_4.ID        // t2 = struct id pointer
        bnel    t1, t3, _initialize_p4+0x18 // ~
        sw      t1, 0x0000(t2)              // if id != NONE, store in struct
        lbu     t1, 0x0002(t0)              // t1 = type
        li      t2, struct.port_4.type      // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store type in struct
        lbu     t1, 0x0006(t0)              // t1 = costume id
        li      t2, struct.port_4.costume   // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store costume id in struct
        
        _end:
        lw      t0, 0x0008(sp)              // ~
        lw      t1, 0x000C(sp)              // ~
        lw      t2, 0x0010(sp)              // ~
        lw      t3, 0x0014(sp)              // load t0-t3
        jal     0x801906D0                  // original line 1
        nop                                 // original line 2
        lw      ra, 0x0004(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }    
    
    // @ Description
    // This function loads the facing direction when a custom spawn position is used
    // v1 = player struct address
    scope load_spawn_dir_: {
        OS.patch_start(0x00053210, 0x800D7A10)
        j   load_spawn_dir_
        nop
        _load_spawn_dir_return:
        OS.patch_end()
        lw      t7, 0x0024(a1)              // original line 1
        or      s0, a0, r0                  // original line 2
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // store t0, t1
        li      t0, struct.table            // t0 = struct table
        lbu     t1, 0x000D(v1)              // ~
        sll     t1, t1, 0x2                 // t1 = offset (player port * 4)
        add     t0, t0, t1                  // t0 = struct table + offset
        lw      t0, 0x0000(t0)              // t0 = port struct address
        lw      t1, 0x0010(t0)              // ~
        slti    t1, t1, 0x4                 // t1 = 1 if spawn_id > 0x4; else t1 = 0
        bnez    t1, _end                    // skip if spawn_id != custom
        nop
        lw      t1, 0x001C(t0)              // t1 = spawn_dir
        sw      t1, 0x0044(v1)              // player facing direction = spawn_dir
        
        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // load t0, t1
        addiu   sp, sp, 0x000C              // deallocate stack space       
        j       _load_spawn_dir_return
        nop
        }
    
    // @ Description
    // This function runs once per frame, per character. Can be used to update character info
    // s0 = player struct address
    scope update_character_: {
        OS.patch_start(0x000621B4, 0x800E69B4)
        j   update_character_
        nop
        _update_character_return:
        OS.patch_end()
        _update_percent:
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // store t0, t1
        li      t0, Global.current_screen   // ~
        lbu     t0, 0x0000(t0)              // t0 = screen_id
        ori     t1, r0, 0x0036              // ~
        bne     t0, t1, _end                // skip if screen_id != training mode
        nop
        li      t0, struct.table            // t0 = struct table
        lbu     t1, 0x000D(s0)              // ~
        sll     t1, t1, 0x2                 // t1 = offset (player port * 4)
        add     t0, t0, t1                  // t0 = struct table + offset
        lw      t0, 0x0000(t0)              // t0 = port struct address
        lhu     t1, 0x002E(s0)              // t1 = current percentage
        sw      t1, 0x000C(t0)              // save percentage to struct
        
        ///////DPAD DOWN to call custom spawn function (used for testing)///////
        //lbu     t0, 0x01BE(s0)              // t0 = dpad_pressed adress
        //andi    t0, t0, 0x0008              // ~
        //beq     t0, r0, _end                // skip if dpad up is not being pressed
        //nop
        //addiu   sp, sp,-0x000C              // allocate stack space
        //sw      a0, 0x0004(sp)              // ~
        //sw      ra, 0x0008(sp)              // store a0, ra
        //or      a0, s0, r0                  // a0 = struct address
        //jal     set_custom_spawn_           // set custom spawn position
        //nop
        //lw      a0, 0x0004(sp)              // ~
        //lw      ra, 0x0008(sp)              // load a0, ra
        //addiu   sp, sp, 0x000C              // deallocate stack space
        
        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // load t0, t1
        addiu   sp, sp, 0x000C              // deallocate stack space
        lw      s0, 0x0020(sp)              // original line 1
        addiu   sp, sp, 0x00A0              // original line 2
        j       _update_character_return
        nop
    }
    
    // @ Description
    // This function runs when training is loaded from stage select, but not when reset is used
    scope load_from_sss_: {
        OS.patch_start(0x00116E20, 0x80190600)
        j   load_from_sss_
        nop
        _load_from_sss_return:
        OS.patch_end()
        
        addiu   t6, t6, 0x5240              // original line 1
        addiu   a0, a0, 0x0870              // original line 2
        
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // store t0, t1
        
        li      t0, reset_counter           // t0 = reset_counter
        sw      r0, 0x0000(t0)              // reset reset_counter value
        
        _initialize_spawns:
        li      t0, struct.port_1.spawn_id  // t0 = port 1 spawn id address
        or      t1, r0, r0                  // t1 = port 1 id
        sw      t1, 0x0000(t0)              // save port id as spawn id
        li      t0, struct.port_2.spawn_id  // t0 = port 2 spawn id address
        addiu   t1, t1, 0x0001              // t1 = port 2 id
        sw      t1, 0x0000(t0)              // save port id as spawn id
        li      t0, struct.port_3.spawn_id  // t0 = port 3 spawn id address
        addiu   t1, t1, 0x0001              // t1 = port 3 id
        sw      t1, 0x0000(t0)              // save port id as spawn id
        li      t0, struct.port_4.spawn_id  // t0 = port 4 spawn id address
        addiu   t1, t1, 0x0001              // t1 = port 4 id
        sw      t1, 0x0000(t0)              // save port id as spawn id
        
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // load t0, t1
        addiu   sp, sp, 0x000C              // deallocate stack space
        j       _load_from_sss_return
        nop
    }
    
    // @ Description
    // This function runs when training is loaded from reset, but not from the stage select screen
    // it also runs when training mode exit is used
    scope load_from_reset_: {
        OS.patch_start(0x00116E88, 0x80190668)
        j   load_from_reset_
        nop
        _exit_game:
        OS.patch_end()
        
        // the original code: resets the game when the branch is taken, exits otherwise
        // bnez    t2, 0x80190654           // original line 1
        // nop                              // original line 2
        
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // store t0, t1
        
        li      t0, reset_counter           // t0 = reset_counter
        lw      t1, 0x0000(t0)              // t1 = reset_counter value
        addiu   t1, t1, 0x00001             // t1 = reset counter value + 1
        sw      t1, 0x0000(t0)              // store reset_counter value
        bnez    t2, _reset_game             // modified original branch
        nop
        
        sw      r0, 0x0000(t0)              // reset reset_counter value
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // load t0, t1
        addiu   sp, sp, 0x000C              // deallocate stack space
        j       _exit_game
        nop
        
        _reset_game:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // load t0, t1
        addiu   sp, sp, 0x000C              // deallocate stack space
        j       0x80190654
        nop
    }
    
    // @ Description
    // This function will reset the player's % to 0
    // @ Arguments
    // a0 - address of the player struct
    // CURRENTLY UNTESTED
    scope reset_percent_: {
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      a1, 0x0004(sp)              // ~
        sw      ra, 0x0008(sp)              // store a1, ra
        lw      a1, 0x002C(a0)              // a1 = percentage
        sub     a1, r0, a1                  // a1 = 0 - percentage
        jal     Character.add_percent_      // subtract current percentage from itself
        nop
        lw      a1, 0x0004(sp)              // ~
        lw      ra, 0x0008(sp)              // load a1, ra
        addiu   sp, sp, 0x000C              // deallocate stack space
        jr      ra                          // return
        nop
    }
    
    // @ Description
    // This function will copy the player's current position to Training.struct.port_x.spawn_pos
    // as well as copying the player's facing direction to Training.struct.port_x.spawn_dir
    // @ Arguments
    // a0 - address of the player struct
    // CURRENTLY UNTESTED
    scope set_custom_spawn_: {
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      t0, 0x0000(sp)              // ~
        sw      t1, 0x0004(sp)              // ~
        sw      t2, 0x0008(sp)              // store t0-t2
        lw      t0, 0x0024(a0)              // t0 = current action id
        ori     t1, r0, 0x000A              // t1 = standing action id
        bne     t0, t1, _end                // skip if current action id != standing
        nop
        
        li      t2, struct.table            // t2 = struct table address
        lbu     t0, 0x000D(a0)              // ~
        sll     t0, t0, 0x2                 // t0 = offset (player port * 4)
        add     t2, t2, t0                  // t2 = struct table + offset
        lw      t2, 0x0000(t2)              // t2 = port struct address
        lw      t0, 0x0078(a0)              // t0 = player position address
        lw      t1, 0x0000(t0)              // t1 = player x position
        sw      t1, 0x0014(t2)              // save player x position to struct
        lw      t1, 0x0004(t0)              // t1 = player y position
        sw      t1, 0x0018(t2)              // save player y position to struct
        lw      t1, 0x0044(a0)              // t1 = player facing direction
        sw      t1, 0x001C(t2)              // save player facing direction to struct
    
        _end:
        lw      t0, 0x0000(sp)              // ~
        lw      t1, 0x0004(sp)              // ~
        lw      t2, 0x0008(sp)              // load t0-t2, a0
        addiu   sp, sp, 0x000C              // deallocate stack space
        jr      ra                          // return
        nop
    }
    
    // @ Description
    // A counter that tracks how many times the current training mode session has been reset.
    // This could be displayed on-screen, but is also useful for differentiating between loads from
    // stage select and loads from the reset function
    reset_counter:
    dw OS.NULL
}

}
}    

// To-Do List
// create functions:
// set custom spawn position (if player state = standing, set custom spawn to current x,y position)
// freeze % toggle?

// End Goal
// create an additional menu that can be easily accessed within training mode
// allowing players to control all of the properties that have been set up in this file
