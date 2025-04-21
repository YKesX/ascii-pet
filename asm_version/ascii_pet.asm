; ASCII Pet - DOS Version
; An enhanced ASCII Pet program in assembly (NASM syntax)
; Uses DOS interrupts for I/O

; NASM directive for COM format
org 100h       ; COM programs start at offset 100h

section .data
    ; Control characters
    CR equ 13
    LF equ 10
    
    ; Messages
    welcome db "Welcome to ASCII Pet Simulator!", CR, LF
            db "Select your pet type:", CR, LF
            db "C - Cat, D - Dog", CR, LF, "$"
    
    controls db "Controls:", CR, LF
             db "F - Feed, P - Pet, A - Play, S - Sleep", CR, LF
             db "I - Show Statistics, Q - Quit", CR, LF, "$"
            
    prompt db CR, LF, "Command: $"
    
    ; Stats messages
    stats_msg db CR, LF, "Pet Statistics:", CR, LF
              db "Hunger: $"
    happy_msg db CR, LF, "Happiness: $"
    energy_msg db CR, LF, "Energy: $"
    
    feed_msg db CR, LF, "You fed your pet!", CR, LF, "$"
    pet_msg db CR, LF, "You petted your pet!", CR, LF, "$"
    play_msg db CR, LF, "You played with your pet!", CR, LF, "$"
    sleep_msg db CR, LF, "Your pet is resting...", CR, LF, "$"
    
    ; Number to display
    number_buffer db "   ", "$"  ; Buffer for displaying stats
    
    ; Cat ASCII art for different moods
    cat_idle db "    /\_/\  ", CR, LF
             db "   ( o.o ) ", CR, LF
             db "    > ^ <  ", CR, LF
             db "   Idle...", CR, LF, "$"
    
    cat_idle2 db "    /\_/\  ", CR, LF
              db "   ( -.- ) ", CR, LF
              db "    > ^ <  ", CR, LF
              db "   Idle...", CR, LF, "$"
             
    cat_happy db "    /\_/\  ", CR, LF
              db "   ( ^.^ ) ", CR, LF
              db "    > ~ <  ", CR, LF
              db "   Happy!", CR, LF, "$"
              
    cat_happy2 db "    /\_/\  ", CR, LF
               db "   ( ^-^ ) ", CR, LF
               db "    > ~ <  ", CR, LF
               db "   Happy!", CR, LF, "$"
              
    cat_angry db "    /\_/\  ", CR, LF
              db "   ( >.< ) ", CR, LF
              db "    > ! <  ", CR, LF
              db "   Angry!", CR, LF, "$"
              
    cat_angry2 db "    /\_/\  ", CR, LF
               db "   ( >_< ) ", CR, LF
               db "    > ! <  ", CR, LF
               db "   Angry!", CR, LF, "$"
              
    cat_sleepy db "    /\_/\  ", CR, LF
               db "   ( -.o ) ", CR, LF
               db "    > z <  ", CR, LF
               db "   Sleepy...", CR, LF, "$"

    cat_sleeping db "    /\_/\  ", CR, LF
                 db "   ( -.- ) zZz", CR, LF
                 db "    > z <  ", CR, LF
                 db "   Sleeping...", CR, LF, "$"
                 
    cat_sleeping2 db "    /\_/\  ", CR, LF
                  db "   ( -.- ) zZ", CR, LF
                  db "    > z <  ", CR, LF
                  db "   Sleeping...", CR, LF, "$"
                  
    cat_hungry db "    /\_/\  ", CR, LF
               db "   ( o.o ) ", CR, LF
               db "    > ◊ <  ", CR, LF
               db "   Hungry...", CR, LF, "$"
               
    cat_hungry2 db "    /\_/\  ", CR, LF
                db "   ( o_o ) ", CR, LF
                db "    > ◊ <  ", CR, LF
                db "   Hungry...", CR, LF, "$"
                
    cat_want_attention db "    /\_/\  ", CR, LF
                       db "   ( o.o ) ", CR, LF
                       db "    > ? <  ", CR, LF
                       db "   Needs attention!", CR, LF, "$"
    
    cat_want_attention2 db "    /\_/\  ", CR, LF
                        db "   ( o_o ) ", CR, LF
                        db "    > ?? <  ", CR, LF
                        db "   Needs attention!", CR, LF, "$"
    
    ; Dog ASCII art for different moods
    dog_idle db "    /^ ^\", CR, LF
             db "   / o o \", CR, LF
             db "   V\ Y /V", CR, LF
             db "    / - \", CR, LF
             db "   /    |", CR, LF
             db "  V__) ||", CR, LF
             db "   Idle...", CR, LF, "$"
             
    dog_idle2 db "    /^ ^\", CR, LF
              db "   / - - \", CR, LF
              db "   V\ Y /V", CR, LF
              db "    / - \", CR, LF
              db "   /    |", CR, LF
              db "  V__) ||", CR, LF
              db "   Idle...", CR, LF, "$"

    dog_happy db "    /^ ^\", CR, LF
              db "   / ^v^ \", CR, LF
              db "   V\ Y /V", CR, LF
              db "    / ~ \", CR, LF
              db "   /    |", CR, LF
              db "  V__) || ", CR, LF
              db "   Happy!", CR, LF, "$"
              
    dog_happy2 db "    /^ ^\", CR, LF
               db "   / ^-^ \", CR, LF
               db "   V\ Y /V", CR, LF
               db "    / ~ \", CR, LF
               db "   /    |", CR, LF
               db "  V__) || ", CR, LF
               db "   Happy!", CR, LF, "$"

    dog_angry db "    /^ ^\", CR, LF
              db "   / ÒvÓ \", CR, LF
              db "   V\ Y /V", CR, LF
              db "    / ! \", CR, LF
              db "   /    |", CR, LF
              db "  V__) || ", CR, LF
              db "   Angry!", CR, LF, "$"
              
    dog_angry2 db "    /^ ^\", CR, LF
               db "   / Ò-Ó \", CR, LF
               db "   V\ Y /V", CR, LF
               db "    / ! \", CR, LF
               db "   /    |", CR, LF
               db "  V__) || ", CR, LF
               db "   Angry!", CR, LF, "$"
               
    dog_sleepy db "    /^ ^\", CR, LF
               db "   / -.- \", CR, LF
               db "   V\ Y /V", CR, LF
               db "    / z \", CR, LF
               db "   /    |", CR, LF
               db "  V__) || ", CR, LF
               db "   Sleepy...", CR, LF, "$"
               
    dog_sleeping db "    /^ ^\", CR, LF
                 db "   / -.- \", CR, LF
                 db "   V\ Y /V", CR, LF
                 db "    / zZz \", CR, LF
                 db "   /    |", CR, LF
                 db "  V__) || ", CR, LF
                 db "   Sleeping...", CR, LF, "$"
                 
    dog_sleeping2 db "    /^ ^\", CR, LF
                  db "   / -.- \", CR, LF
                  db "   V\ Y /V", CR, LF
                  db "    / zZ \", CR, LF
                  db "   /    |", CR, LF
                  db "  V__) || ", CR, LF
                  db "   Sleeping...", CR, LF, "$"
                  
    dog_hungry db "    /^ ^\", CR, LF
               db "   / o.o \", CR, LF
               db "   V\ Y /V", CR, LF
               db "    / ◊ \", CR, LF
               db "   /    |", CR, LF
               db "  V__) || ", CR, LF
               db "   Hungry...", CR, LF, "$"
               
    dog_hungry2 db "    /^ ^\", CR, LF
                db "   / o_o \", CR, LF
                db "   V\ Y /V", CR, LF
                db "    / ◊◊ \", CR, LF
                db "   /    |", CR, LF
                db "  V__) || ", CR, LF
                db "   Hungry...", CR, LF, "$"
                
    dog_want_attention db "    /^ ^\", CR, LF
                       db "   / o.o \", CR, LF
                       db "   V\ Y /V", CR, LF
                       db "    / ? \", CR, LF
                       db "   /    |", CR, LF
                       db "  V__) || ", CR, LF
                       db "   Needs attention!", CR, LF, "$"
                       
    dog_want_attention2 db "    /^ ^\", CR, LF
                        db "   / o_o \", CR, LF
                        db "   V\ Y /V", CR, LF
                        db "    / ?? \", CR, LF
                        db "   /    |", CR, LF
                        db "  V__) || ", CR, LF
                        db "   Needs attention!", CR, LF, "$"
    
section .bss
    current_pet resb 1      ; 1=cat, 2=dog
    current_mood resb 1     ; 0=idle, 1=happy, 2=angry, 3=sleepy, 4=sleeping, 5=hungry, 6=wants_attention
    animation_frame resb 1  ; Animation frame index
    hunger_level resb 1     ; Hunger level (0-100)
    happiness_level resb 1  ; Happiness level (0-100)
    energy_level resb 1     ; Energy level (0-100)
    tick_counter resb 1     ; To track time

section .text
    global start    ; Entry point for COM files

; COM file entry point
start:
    ; Initialize variables
    mov byte [current_pet], 1      ; Default to cat
    mov byte [current_mood], 0     ; Default to idle
    mov byte [animation_frame], 0  ; First frame
    mov byte [hunger_level], 80    ; Start with 80% hunger
    mov byte [happiness_level], 50 ; Start with 50% happiness
    mov byte [energy_level], 100   ; Start with 100% energy
    mov byte [tick_counter], 0     ; Reset tick counter
    
    ; Setup program
    call clear_screen
    
    ; Display welcome message and pet selection
    mov dx, welcome
    call print_string
    
    ; Get pet selection
    mov ah, 01h         ; DOS function: get character with echo
    int 21h             ; Call DOS
    
    ; Process selection
    cmp al, 'c'
    je .set_cat
    cmp al, 'C'
    je .set_cat
    cmp al, 'd'
    je .set_dog
    cmp al, 'D'
    je .set_dog
    jmp .set_cat        ; Default to cat if invalid input
    
.set_cat:
    mov byte [current_pet], 1
    jmp main_loop

.set_dog:
    mov byte [current_pet], 2
    jmp main_loop
    
main_loop:
    ; Clear screen
    call clear_screen
    
    ; Update pet state based on needs
    call update_pet_state
    
    ; Display current pet mood based on state
    call display_pet
    
    ; Display controls
    mov dx, controls
    call print_string
    
    ; Display prompt
    mov dx, prompt
    call print_string
    
    ; Get user input
    mov ah, 01h         ; DOS function: get character with echo
    int 21h             ; Call DOS
    
    ; Process input (AL contains character)
    cmp al, 'q'         ; Check for quit
    je exit_program
    cmp al, 'Q'
    je exit_program
    
    cmp al, 'f'         ; Check for feed
    je feed_pet
    cmp al, 'F'
    je feed_pet
    
    cmp al, 'p'         ; Check for pet
    je pet_pet
    cmp al, 'P'
    je pet_pet
    
    cmp al, 'a'         ; Check for play
    je play_with_pet
    cmp al, 'A'
    je play_with_pet
    
    cmp al, 's'         ; Check for sleep
    je put_to_sleep
    cmp al, 'S'
    je put_to_sleep
    
    cmp al, 'i'         ; Check for stats
    je show_stats
    cmp al, 'I'
    je show_stats
    
    ; Advance tick counter regardless
    inc byte [tick_counter]
    and byte [tick_counter], 0Fh  ; Modulo 16
    
    ; Toggle animation frame periodically
    test byte [tick_counter], 8
    jz .keep_frame
    mov byte [animation_frame], 1
    jmp .frame_done
.keep_frame:
    mov byte [animation_frame], 0
.frame_done:
    
    jmp main_loop       ; Continue loop

feed_pet:
    ; Reduce hunger
    mov al, [hunger_level]
    cmp al, 20
    jbe .hunger_low
    sub al, 20
    jmp .set_hunger
.hunger_low:
    xor al, al
.set_hunger:
    mov [hunger_level], al
    
    ; Display message
    mov dx, feed_msg
    call print_string
    
    ; Wait for a moment
    call delay
    
    jmp main_loop

pet_pet:
    ; Increase happiness
    mov al, [happiness_level]
    cmp al, 80
    jae .happiness_high
    add al, 20
    jmp .set_happiness
.happiness_high:
    mov al, 100
.set_happiness:
    mov [happiness_level], al
    
    ; Display message
    mov dx, pet_msg
    call print_string
    
    ; Wait for a moment
    call delay
    
    jmp main_loop

play_with_pet:
    ; Increase happiness but reduce energy
    mov al, [happiness_level]
    cmp al, 80
    jae .happiness_high
    add al, 20
    jmp .set_happiness
.happiness_high:
    mov al, 100
.set_happiness:
    mov [happiness_level], al
    
    ; Reduce energy
    mov al, [energy_level]
    cmp al, 15
    jbe .energy_low
    sub al, 15
    jmp .set_energy
.energy_low:
    xor al, al
.set_energy:
    mov [energy_level], al
    
    ; Display message
    mov dx, play_msg
    call print_string
    
    ; Wait for a moment
    call delay
    
    jmp main_loop

put_to_sleep:
    ; Set mood to sleeping
    mov byte [current_mood], 4
    
    ; Display message
    mov dx, sleep_msg
    call print_string
    
    ; Increase energy level
    mov al, [energy_level]
    cmp al, 80
    jae .energy_high
    add al, 20
    jmp .set_energy
.energy_high:
    mov al, 100
.set_energy:
    mov [energy_level], al
    
    ; Wait for a moment
    call delay
    
    jmp main_loop

show_stats:
    ; Display hunger level
    mov dx, stats_msg
    call print_string
    mov al, [hunger_level]
    call print_number
    
    ; Display happiness level
    mov dx, happy_msg
    call print_string
    mov al, [happiness_level]
    call print_number
    
    ; Display energy level
    mov dx, energy_msg
    call print_string
    mov al, [energy_level]
    call print_number
    
    ; Wait for a keypress
    mov ah, 01h
    int 21h
    
    jmp main_loop
    
update_pet_state:
    ; Gradually change pet state based on stats
    
    ; If energy is very low, become sleepy
    mov al, [energy_level]
    cmp al, 20
    jbe .make_sleepy
    
    ; If hunger is high, become hungry
    mov al, [hunger_level]
    cmp al, 80
    jae .make_hungry
    
    ; If happiness is low, make angry or wants attention
    mov al, [happiness_level]
    cmp al, 30
    jbe .make_attention
    
    ; Default mood is idle
    mov byte [current_mood], 0
    jmp .done
    
.make_sleepy:
    mov byte [current_mood], 3
    mov al, [hunger_level]
    cmp al, 90
    jae .make_hungry    ; Hunger can override sleepiness
    jmp .done
    
.make_hungry:
    mov byte [current_mood], 5
    jmp .done
    
.make_attention:
    ; Toggle between angry and want attention based on tick counter
    test byte [tick_counter], 8
    jz .make_angry
    mov byte [current_mood], 6
    jmp .done
    
.make_angry:
    mov byte [current_mood], 2
    
.done:
    ; Increase hunger slightly
    mov al, [hunger_level]
    cmp al, 98
    jae .max_hunger
    add al, 2
    jmp .set_hunger
.max_hunger:
    mov al, 100
.set_hunger:
    mov [hunger_level], al
    
    ; Decrease happiness slightly
    mov al, [happiness_level]
    cmp al, 2
    jbe .min_happiness
    sub al, 2
    jmp .set_happiness
.min_happiness:
    xor al, al
.set_happiness:
    mov [happiness_level], al
    
    ; Decrease energy if not sleeping
    cmp byte [current_mood], 4
    je .no_energy_change
    
    mov al, [energy_level]
    cmp al, 1
    jbe .min_energy
    dec al
    jmp .set_energy
.min_energy:
    xor al, al
.set_energy:
    mov [energy_level], al
    
.no_energy_change:
    ret
    
; ----- Display procedures -----

display_pet:
    mov ah, 09h
    
    ; Check pet type first
    cmp byte [current_pet], 2
    je display_dog
    
    ; Display cat ASCII art based on current mood and frame
    cmp byte [current_mood], 0
    je .display_idle
    cmp byte [current_mood], 1
    je .display_happy
    cmp byte [current_mood], 2
    je .display_angry
    cmp byte [current_mood], 3
    je .display_sleepy
    cmp byte [current_mood], 4
    je .display_sleeping
    cmp byte [current_mood], 5
    je .display_hungry
    cmp byte [current_mood], 6
    je .display_attention
    jmp .display_idle  ; Default
    
.display_idle:
    cmp byte [animation_frame], 0
    jne .idle_frame2
    mov dx, cat_idle
    jmp .display
.idle_frame2:
    mov dx, cat_idle2
    jmp .display
    
.display_happy:
    cmp byte [animation_frame], 0
    jne .happy_frame2
    mov dx, cat_happy
    jmp .display
.happy_frame2:
    mov dx, cat_happy2
    jmp .display
    
.display_angry:
    cmp byte [animation_frame], 0
    jne .angry_frame2
    mov dx, cat_angry
    jmp .display
.angry_frame2:
    mov dx, cat_angry2
    jmp .display
    
.display_sleepy:
    mov dx, cat_sleepy
    jmp .display
    
.display_sleeping:
    cmp byte [animation_frame], 0
    jne .sleep_frame2
    mov dx, cat_sleeping
    jmp .display
.sleep_frame2:
    mov dx, cat_sleeping2
    jmp .display
    
.display_hungry:
    cmp byte [animation_frame], 0
    jne .hungry_frame2
    mov dx, cat_hungry
    jmp .display
.hungry_frame2:
    mov dx, cat_hungry2
    jmp .display
    
.display_attention:
    cmp byte [animation_frame], 0
    jne .attention_frame2
    mov dx, cat_want_attention
    jmp .display
.attention_frame2:
    mov dx, cat_want_attention2
    jmp .display
    
.display:
    int 21h
    ret

display_dog:
    ; Display dog ASCII art based on current mood
    cmp byte [current_mood], 0
    je .display_idle
    cmp byte [current_mood], 1
    je .display_happy
    cmp byte [current_mood], 2
    je .display_angry
    cmp byte [current_mood], 3
    je .display_sleepy
    cmp byte [current_mood], 4
    je .display_sleeping
    cmp byte [current_mood], 5
    je .display_hungry
    cmp byte [current_mood], 6
    je .display_attention
    jmp .display_idle  ; Default
    
.display_idle:
    cmp byte [animation_frame], 0
    jne .idle_frame2
    mov dx, dog_idle
    jmp .display
.idle_frame2:
    mov dx, dog_idle2
    jmp .display
    
.display_happy:
    cmp byte [animation_frame], 0
    jne .happy_frame2
    mov dx, dog_happy
    jmp .display
.happy_frame2:
    mov dx, dog_happy2
    jmp .display
    
.display_angry:
    cmp byte [animation_frame], 0
    jne .angry_frame2
    mov dx, dog_angry
    jmp .display
.angry_frame2:
    mov dx, dog_angry2
    jmp .display
    
.display_sleepy:
    mov dx, dog_sleepy
    jmp .display
    
.display_sleeping:
    cmp byte [animation_frame], 0
    jne .sleep_frame2
    mov dx, dog_sleeping
    jmp .display
.sleep_frame2:
    mov dx, dog_sleeping2
    jmp .display
    
.display_hungry:
    cmp byte [animation_frame], 0
    jne .hungry_frame2
    mov dx, dog_hungry
    jmp .display
.hungry_frame2:
    mov dx, dog_hungry2
    jmp .display
    
.display_attention:
    cmp byte [animation_frame], 0
    jne .attention_frame2
    mov dx, dog_want_attention
    jmp .display
.attention_frame2:
    mov dx, dog_want_attention2
    jmp .display
    
.display:
    int 21h
    ret
    
; ----- Utility procedures -----

; Print a string using DOS
; Input: DX - address of '$' terminated string
print_string:
    mov ah, 09h         ; DOS function: print string
    int 21h             ; Call DOS
    ret
    
; Print a number (0-100)
; Input: AL - number to print
print_number:
    ; Convert number to ASCII string
    mov cl, 10
    xor ah, ah
    div cl              ; Divide by 10, AL = quotient, AH = remainder
    add al, '0'         ; Convert to ASCII
    add ah, '0'         ; Convert to ASCII
    
    ; Store in buffer
    mov [number_buffer], al    ; First digit
    mov [number_buffer+1], ah  ; Second digit
    
    ; Print the buffer
    mov dx, number_buffer
    call print_string
    ret
    
; Clear the screen using DOS
clear_screen:
    mov ah, 00h         ; Video function: set video mode
    mov al, 03h         ; 80x25 text mode
    int 10h             ; Call BIOS video service
    ret
    
; Short delay
delay:
    mov cx, 10000       ; Adjust for desired delay
.loop:
    push cx
    pop cx
    loop .loop
    ret

exit_program:
    ; Return control to DOS
    mov ah, 4Ch         ; DOS function: terminate program
    xor al, al          ; Return code 0
    int 21h             ; Call DOS
