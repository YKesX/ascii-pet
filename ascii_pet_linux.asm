; ASCII Pet - Linux version (NASM syntax)
; A simplified ASCII pet simulator with multiple interactions and statistics tracking
; Uses Linux syscalls for display and input

section .data
    ; Control characters
    NULL equ 0
    LF equ 10
    
    ; ANSI escape codes
    clear_screen_seq db 27, "[2J", 27, "[H", NULL  ; Clear screen and move cursor to home
    clear_screen_len equ $ - clear_screen_seq - 1   ; Length without NULL
    
    ; Messages
    welcome db "Welcome to ASCII Pet Simulator!", LF
            db "Choose your pet type:", LF
            db "1 - Cat", LF
            db "2 - Dog", LF, LF, NULL
    welcome_len equ $ - welcome - 1
    
    pet_name_prompt db "Enter your pet's name: ", NULL
    pet_name_prompt_len equ $ - pet_name_prompt - 1
    
    menu_header db LF, "What would you like to do with your pet?", LF
                db "1 - Feed pet", LF
                db "2 - Pet (give attention)", LF
                db "3 - Play with pet", LF
                db "4 - Insult pet", LF
                db "5 - Let pet sleep", LF
                db "6 - Check pet status", LF
                db "7 - Change pet type", LF
                db "8 - Save pet data", LF
                db "9 - Load pet data", LF
                db "0 - Exit", LF, LF
                db "Command: ", NULL
    menu_header_len equ $ - menu_header - 1

    status_header db "PET STATUS:", LF, LF, NULL
    status_header_len equ $ - status_header - 1
    
    stat_feedings db "Total feedings: ", NULL
    stat_feedings_len equ $ - stat_feedings - 1
    
    stat_pettings db "Total pettings: ", NULL
    stat_pettings_len equ $ - stat_pettings - 1
    
    stat_plays db "Total plays: ", NULL
    stat_plays_len equ $ - stat_plays - 1
    
    stat_insults db "Total insults: ", NULL
    stat_insults_len equ $ - stat_insults - 1

    stat_sleeps db "Total sleeps: ", NULL
    stat_sleeps_len equ $ - stat_sleeps - 1

    stat_age db "Pet age (days): ", NULL
    stat_age_len equ $ - stat_age - 1

    hunger_text db "Hunger level: ", NULL
    hunger_text_len equ $ - hunger_text - 1

    energy_text db "Energy level: ", NULL
    energy_text_len equ $ - energy_text - 1

    happiness_text db "Happiness level: ", NULL
    happiness_text_len equ $ - happiness_text - 1
    
    pet_fed_msg db "You fed your pet!", LF, NULL
    pet_fed_len equ $ - pet_fed_msg - 1
    
    pet_attention_msg db "You gave your pet attention!", LF, NULL
    pet_attention_len equ $ - pet_attention_msg - 1
    
    pet_play_msg db "You played with your pet!", LF, NULL
    pet_play_len equ $ - pet_play_msg - 1
    
    pet_insulted_msg db "You insulted your pet! It looks angry...", LF, NULL
    pet_insulted_len equ $ - pet_insulted_msg - 1
    
    pet_sleep_msg db "Your pet is now sleeping...", LF, NULL
    pet_sleep_len equ $ - pet_sleep_msg - 1

    pet_save_msg db "Pet data saved successfully!", LF, NULL
    pet_save_len equ $ - pet_save_msg - 1

    pet_load_msg db "Pet data loaded successfully!", LF, NULL
    pet_load_len equ $ - pet_load_msg - 1

    pet_save_error db "Error saving pet data!", LF, NULL
    pet_save_error_len equ $ - pet_save_error - 1

    pet_load_error db "Error loading pet data! Starting with new pet.", LF, NULL
    pet_load_error_len equ $ - pet_load_error - 1

    random_event_msg db "A random event occurred! ", NULL
    random_event_msg_len equ $ - random_event_msg - 1

    random_happy db "Your pet found a toy and is happy!", LF, NULL
    random_happy_len equ $ - random_happy - 1

    random_sad db "Your pet is feeling a bit lonely...", LF, NULL
    random_sad_len equ $ - random_sad - 1

    random_hungry db "Your pet is getting hungry!", LF, NULL
    random_hungry_len equ $ - random_hungry - 1
    
    press_any_key db "Press any key to continue...", LF, NULL
    press_any_key_len equ $ - press_any_key - 1

    ; Save file name
    save_file_name db "pet_save.dat", 0
    
    ; Cat ASCII art for different moods (simplified)
    cat_idle db "    /\_/\  ", LF
             db "   ( o.o ) ", LF
             db "    > ^ <  ", LF
             db "   Idle...", LF, NULL
    cat_idle_len equ $ - cat_idle - 1
    
    cat_idle2 db "    /\_/\  ", LF
              db "   ( -.- ) ", LF
              db "    > ^ <  ", LF
              db "   Idle...", LF, NULL
    cat_idle2_len equ $ - cat_idle2 - 1
             
    cat_happy db "    /\_/\  ", LF
              db "   ( ^.^ ) ", LF
              db "    > ~ <  ", LF
              db "   Happy!", LF, NULL
    cat_happy_len equ $ - cat_happy - 1
    
    cat_happy2 db "    /\_/\  ", LF
               db "   ( ^-^ ) ", LF
               db "    > ~ <  ", LF
               db "   Happy!", LF, NULL
    cat_happy2_len equ $ - cat_happy2 - 1
              
    cat_angry db "    /\_/\  ", LF
              db "   ( >.< ) ", LF
              db "    > ! <  ", LF
              db "   Angry!", LF, NULL
    cat_angry_len equ $ - cat_angry - 1
    
    cat_angry2 db "    /\_/\  ", LF
               db "   ( >_< ) ", LF
               db "    > ! <  ", LF
               db "   Angry!", LF, NULL
    cat_angry2_len equ $ - cat_angry2 - 1
              
    cat_sleepy db "    /\_/\  ", LF
               db "   ( -.o ) ", LF
               db "    > z <  ", LF
               db "   Sleepy...", LF, NULL
    cat_sleepy_len equ $ - cat_sleepy - 1

    cat_sleeping db "    /\_/\  ", LF
                 db "   ( -.- ) zZz", LF
                 db "    > z <  ", LF
                 db "   Sleeping...", LF, NULL
    cat_sleeping_len equ $ - cat_sleeping - 1
    
    cat_sleeping2 db "    /\_/\  ", LF
                  db "   ( -.- ) zZ", LF
                  db "    > z <  ", LF
                  db "   Sleeping...", LF, NULL
    cat_sleeping2_len equ $ - cat_sleeping2 - 1

    cat_hungry db "    /\_/\  ", LF
               db "   ( o.o ) ", LF
               db "    > ◊ <  ", LF
               db "   Hungry...", LF, NULL
    cat_hungry_len equ $ - cat_hungry - 1
    
    cat_hungry2 db "    /\_/\  ", LF
                db "   ( o_o ) ", LF
                db "    > ◊ <  ", LF
                db "   Hungry...", LF, NULL
    cat_hungry2_len equ $ - cat_hungry2 - 1
    
    cat_want_attention db "    /\_/\  ", LF
                       db "   ( o.o ) ", LF
                       db "    > ? <  ", LF
                       db "   Needs attention!", LF, NULL
    cat_want_attention_len equ $ - cat_want_attention - 1
    
    cat_want_attention2 db "    /\_/\  ", LF
                        db "   ( o_o ) ", LF
                        db "    > ?? <  ", LF
                        db "   Needs attention!", LF, NULL
    cat_want_attention2_len equ $ - cat_want_attention2 - 1

    ; Dog ASCII art for different moods
    dog_idle db "    /^ ^\  ", LF
             db "   / o o \ ", LF
             db "   V\ Y /V ", LF
             db "    / - \  ", LF
             db "   /    | ", LF
             db "  V__) || ", LF
             db "   Idle...", LF, NULL
    dog_idle_len equ $ - dog_idle - 1
    
    dog_idle2 db "    /^ ^\  ", LF
              db "   / - - \ ", LF
              db "   V\ Y /V ", LF
              db "    / - \  ", LF
              db "   /    | ", LF
              db "  V__) || ", LF
              db "   Idle...", LF, NULL
    dog_idle2_len equ $ - dog_idle2 - 1
             
    dog_happy db "    /^ ^\  ", LF
              db "   / ^.^ \ ", LF
              db "   V\ Y /V ", LF
              db "    / ~ \  ", LF
              db "   /    | ", LF
              db "  V__) || ", LF
              db "   Happy!", LF, NULL
    dog_happy_len equ $ - dog_happy - 1
    
    dog_happy2 db "    /^ ^\  ", LF
               db "   / ^-^ \ ", LF
               db "   V\ Y /V ", LF
               db "    / ~ \  ", LF
               db "   /    | ", LF
               db "  V__) || ", LF
               db "   Happy!", LF, NULL
    dog_happy2_len equ $ - dog_happy2 - 1
              
    dog_angry db "    /^ ^\  ", LF
              db "   / >.< \ ", LF
              db "   V\ Y /V ", LF
              db "    / ! \  ", LF
              db "   /    | ", LF
              db "  V__) || ", LF
              db "   Angry!", LF, NULL
    dog_angry_len equ $ - dog_angry - 1
    
    dog_angry2 db "    /^ ^\  ", LF
               db "   / >_< \ ", LF
               db "   V\ Y /V ", LF
               db "    / ! \  ", LF
               db "   /    | ", LF
               db "  V__) || ", LF
               db "   Angry!", LF, NULL
    dog_angry2_len equ $ - dog_angry2 - 1
              
    dog_sleepy db "    /^ ^\  ", LF
               db "   / -.o \ ", LF
               db "   V\ Y /V ", LF
               db "    / z \  ", LF
               db "   /    | ", LF
               db "  V__) || ", LF
               db "   Sleepy...", LF, NULL
    dog_sleepy_len equ $ - dog_sleepy - 1

    dog_sleeping db "    /^ ^\  ", LF
                 db "   / -.- \ zZz", LF
                 db "   V\ Y /V ", LF
                 db "    / z \  ", LF
                 db "   /    | ", LF
                 db "  V__) || ", LF
                 db "   Sleeping...", LF, NULL
    dog_sleeping_len equ $ - dog_sleeping - 1
    
    dog_sleeping2 db "    /^ ^\  ", LF
                  db "   / -.- \ zZ", LF
                  db "   V\ Y /V ", LF
                  db "    / z \  ", LF
                  db "   /    | ", LF
                  db "  V__) || ", LF
                  db "   Sleeping...", LF, NULL
    dog_sleeping2_len equ $ - dog_sleeping2 - 1

    dog_hungry db "    /^ ^\  ", LF
               db "   / o.o \ ", LF
               db "   V\ Y /V ", LF
               db "    / ◊ \  ", LF
               db "   /    | ", LF
               db "  V__) || ", LF
               db "   Hungry...", LF, NULL
    dog_hungry_len equ $ - dog_hungry - 1
    
    dog_hungry2 db "    /^ ^\  ", LF
                db "   / o_o \ ", LF
                db "   V\ Y /V ", LF
                db "    / ◊◊ \  ", LF
                db "   /    | ", LF
                db "  V__) || ", LF
                db "   Hungry...", LF, NULL
    dog_hungry2_len equ $ - dog_hungry2 - 1
    
    dog_want_attention db "    /^ ^\  ", LF
                       db "   / o.o \ ", LF
                       db "   V\ Y /V ", LF
                       db "    / ? \  ", LF
                       db "   /    | ", LF
                       db "  V__) || ", LF
                       db "   Needs attention!", LF, NULL
    dog_want_attention_len equ $ - dog_want_attention - 1
    
    dog_want_attention2 db "    /^ ^\  ", LF
                        db "   / o_o \ ", LF
                        db "   V\ Y /V ", LF
                        db "    / ?? \  ", LF
                        db "   /    | ", LF
                        db "  V__) || ", LF
                        db "   Needs attention!", LF, NULL
    dog_want_attention2_len equ $ - dog_want_attention2 - 1
    
    ; State variables
    pet_type db 1                  ; 1 = cat, 2 = dog
    current_mood db 0              ; 0 = idle, 1 = happy, 2 = angry, 3 = sleepy, 4 = sleeping, 5 = hungry, 6 = wants_attention
    animation_frame db 0           ; Animation frame index (0 or 1)
    hunger_level db 50             ; Hunger level (0-100), 0=full, 100=starving
    happiness_level db 50          ; Happiness level (0-100)
    energy_level db 80             ; Energy level (0-100)
    tick_counter db 0              ; To track time
    pet_age dd 0                   ; Age in days
    last_interaction_time dd 0     ; Last interaction time for aging
    
    ; Statistics
    total_feedings dd 0            ; Number of times pet was fed
    total_pettings dd 0            ; Number of times pet was petted
    total_plays dd 0               ; Number of times pet was played with
    total_insults dd 0             ; Number of times pet was insulted
    total_sleeps dd 0              ; Number of times pet slept
    
    ; Number to ASCII conversion buffer
    num_buffer db "0000000000", NULL
    
    ; Buffer for pet name (max 20 chars)
    pet_name_buffer_len equ 21     ; 20 chars + NULL
    pet_name db "Pet", 0           ; Default name
    pet_name_len db 3              ; Length of pet name

    ; Random number counter (to help with pseudo-randomness)
    random_counter dd 0
    
section .bss
    input_char resb 1              ; Space for one character input
    input_buffer resb 32           ; General input buffer
    pet_name_buffer resb pet_name_buffer_len  ; Buffer for pet name input
    save_buffer resb 128           ; Buffer for save/load data (increased for additional stats)
    save_file_handle resd 1        ; File handle for save file
    
section .text
    global _start

; Linux syscall numbers
SYS_READ    equ 0
SYS_WRITE   equ 1
SYS_OPEN    equ 2
SYS_CLOSE   equ 3
SYS_LSEEK   equ 19
SYS_EXIT    equ 60
SYS_TIME    equ 201

; File descriptors
STDIN       equ 0
STDOUT      equ 1
STDERR      equ 2

; File open flags
O_RDONLY    equ 0
O_WRONLY    equ 1
O_RDWR      equ 2
O_CREAT     equ 64
O_TRUNC     equ 512

; File permissions
S_IRUSR     equ 00400
S_IWUSR     equ 00200
S_IRGRP     equ 00040
S_IROTH     equ 00004

_start:
    ; Try to load pet data on startup
    call load_pet_data
    
    ; Show welcome message
    call clear_screen
    mov rsi, welcome
    mov rdx, welcome_len
    call print_string
    
    ; Get pet type choice
    call get_single_key
    
    ; Only accept 1 or 2
    cmp byte [input_char], '1'
    je .valid_pet_type
    cmp byte [input_char], '2'
    je .valid_pet_type
    mov byte [pet_type], 1  ; Default to cat if invalid
    jmp .ask_name
    
.valid_pet_type:
    sub byte [input_char], '0'
    mov al, [input_char]
    mov [pet_type], al

.ask_name:
    ; Get pet name
    call clear_screen
    mov rsi, pet_name_prompt
    mov rdx, pet_name_prompt_len
    call print_string
    
    ; Read pet name
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, pet_name_buffer
    mov rdx, pet_name_buffer_len
    syscall
    
    ; Calculate actual length (removing LF)
    dec rax
    mov [pet_name_len], al
    
    ; Copy to pet_name (respecting length and NULL termination)
    mov rcx, 0
.copy_name_loop:
    cmp rcx, rax
    jge .copy_name_done
    mov dl, [pet_name_buffer + rcx]
    mov [pet_name + rcx], dl
    inc rcx
    jmp .copy_name_loop
.copy_name_done:
    mov byte [pet_name + rcx], 0  ; NULL terminate

    ; Get current system time for initialization
    mov rax, SYS_TIME
    mov rdi, 0
    syscall
    mov [last_interaction_time], rax

; Main program loop
main_loop:
    ; Update pet state based on time
    call update_pet_state
    
    ; Display pet status
    call clear_screen
    call display_pet
    
    ; Show menu
    mov rsi, menu_header
    mov rdx, menu_header_len
    call print_string
    
    ; Get menu choice
    call get_single_key
    
    ; Handle menu choice
    cmp byte [input_char], '0'
    je exit_program
    
    cmp byte [input_char], '1'
    je feed_pet
    
    cmp byte [input_char], '2'
    je pet_attention
    
    cmp byte [input_char], '3'
    je play_with_pet
    
    cmp byte [input_char], '4'
    je insult_pet
    
    cmp byte [input_char], '5'
    je let_pet_sleep
    
    cmp byte [input_char], '6'
    je check_status
    
    cmp byte [input_char], '7'
    je change_pet_type

    cmp byte [input_char], '8'
    je save_pet
    
    cmp byte [input_char], '9'
    je load_pet
    
    ; Invalid choice, just loop back
    jmp main_loop

;--------------------------------
; Actions
;--------------------------------

feed_pet:
    ; Increase stats
    mov rax, [total_feedings]
    inc rax
    mov [total_feedings], rax
    
    ; Decrease hunger (improve hunger level)
    mov al, [hunger_level]
    sub al, 30
    jns .no_hunger_underflow
    mov al, 0
.no_hunger_underflow:
    mov [hunger_level], al
    
    ; Change mood and display message
    mov byte [current_mood], 1  ; Set to happy
    
    ; Happiness increases a bit when fed
    mov al, [happiness_level]
    add al, 10
    cmp al, 100
    jle .no_happy_overflow
    mov al, 100
.no_happy_overflow:
    mov [happiness_level], al
    
    call clear_screen
    call display_pet
    
    mov rsi, pet_fed_msg
    mov rdx, pet_fed_len
    call print_string
    
    call wait_for_key
    jmp main_loop

pet_attention:
    ; Increase stats
    mov rax, [total_pettings]
    inc rax
    mov [total_pettings], rax
    
    ; Increase happiness
    mov al, [happiness_level]
    add al, 20
    cmp al, 100
    jle .no_happy_overflow
    mov al, 100
.no_happy_overflow:
    mov [happiness_level], al
    
    ; Change mood
    mov byte [current_mood], 1  ; Set to happy
    
    call clear_screen
    call display_pet
    
    mov rsi, pet_attention_msg
    mov rdx, pet_attention_len
    call print_string
    
    call wait_for_key
    jmp main_loop

play_with_pet:
    ; Increase stats
    mov rax, [total_plays]
    inc rax
    mov [total_plays], rax
    
    ; Decrease energy (pet gets tired)
    mov al, [energy_level]
    sub al, 20
    jns .no_energy_underflow
    mov al, 0
.no_energy_underflow:
    mov [energy_level], al
    
    ; Increase hunger (playing makes pet hungry)
    mov al, [hunger_level]
    add al, 10
    cmp al, 100
    jle .no_hunger_overflow
    mov al, 100
.no_hunger_overflow:
    mov [hunger_level], al
    
    ; Increase happiness
    mov al, [happiness_level]
    add al, 25
    cmp al, 100
    jle .no_happy_overflow
    mov al, 100
.no_happy_overflow:
    mov [happiness_level], al
    
    ; Change mood
    mov byte [current_mood], 1  ; Set to happy
    
    call clear_screen
    call display_pet
    
    mov rsi, pet_play_msg
    mov rdx, pet_play_len
    call print_string
    
    call wait_for_key
    jmp main_loop

insult_pet:
    ; Increase stats
    mov rax, [total_insults]
    inc rax
    mov [total_insults], rax
    
    ; Decrease happiness
    mov al, [happiness_level]
    sub al, 30
    jns .no_happy_underflow
    mov al, 0
.no_happy_underflow:
    mov [happiness_level], al
    
    ; Change mood
    mov byte [current_mood], 2  ; Set to angry
    
    call clear_screen
    call display_pet
    
    mov rsi, pet_insulted_msg
    mov rdx, pet_insulted_len
    call print_string
    
    call wait_for_key
    jmp main_loop

let_pet_sleep:
    ; Increase stats
    mov rax, [total_sleeps]
    inc rax
    mov [total_sleeps], rax
    
    ; Increase energy level
    mov al, [energy_level]
    add al, 50
    cmp al, 100
    jle .no_energy_overflow
    mov al, 100
.no_energy_overflow:
    mov [energy_level], al
    
    ; Change mood
    mov byte [current_mood], 4  ; Set to sleeping
    
    call clear_screen
    call display_pet
    
    mov rsi, pet_sleep_msg
    mov rdx, pet_sleep_len
    call print_string
    
    call wait_for_key
    jmp main_loop

check_status:
    call clear_screen
    call display_pet
    
    ; Display pet stats
    mov rsi, status_header
    mov rdx, status_header_len
    call print_string
    
    ; Display feeding count
    mov rsi, stat_feedings
    mov rdx, stat_feedings_len
    call print_string
    mov rax, [total_feedings]
    call print_number
    call print_newline
    
    ; Display petting count
    mov rsi, stat_pettings
    mov rdx, stat_pettings_len
    call print_string
    mov rax, [total_pettings]
    call print_number
    call print_newline
    
    ; Display play count
    mov rsi, stat_plays
    mov rdx, stat_plays_len
    call print_string
    mov rax, [total_plays]
    call print_number
    call print_newline
    
    ; Display insult count
    mov rsi, stat_insults
    mov rdx, stat_insults_len
    call print_string
    mov rax, [total_insults]
    call print_number
    call print_newline
    
    ; Display sleep count
    mov rsi, stat_sleeps
    mov rdx, stat_sleeps_len
    call print_string
    mov rax, [total_sleeps]
    call print_number
    call print_newline
    
    ; Display age
    mov rsi, stat_age
    mov rdx, stat_age_len
    call print_string
    mov rax, [pet_age]
    call print_number
    call print_newline
    
    ; Display hunger level
    mov rsi, hunger_text
    mov rdx, hunger_text_len
    call print_string
    movzx rax, byte [hunger_level]
    call print_number
    call print_newline
    
    ; Display energy level
    mov rsi, energy_text
    mov rdx, energy_text_len
    call print_string
    movzx rax, byte [energy_level]
    call print_number
    call print_newline
    
    ; Display happiness level
    mov rsi, happiness_text
    mov rdx, happiness_text_len
    call print_string
    movzx rax, byte [happiness_level]
    call print_number
    call print_newline
    
    call wait_for_key
    jmp main_loop

change_pet_type:
    ; Toggle pet type (1->2, 2->1)
    mov al, [pet_type]
    xor al, 3      ; XOR with 11b (3 decimal) to toggle between 1 and 2
    mov [pet_type], al
    
    jmp main_loop

save_pet:
    ; Open file for writing
    mov rax, SYS_OPEN
    mov rdi, save_file_name
    mov rsi, O_WRONLY | O_CREAT | O_TRUNC
    mov rdx, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH
    syscall
    
    ; Check for error
    cmp rax, 0
    jl .save_error
    
    ; Store file handle
    mov [save_file_handle], rax
    
    ; Fill save buffer with data
    mov edi, save_buffer
    
    ; Save pet type
    mov al, [pet_type]
    mov [edi], al
    inc edi
    
    ; Save mood
    mov al, [current_mood]
    mov [edi], al
    inc edi
    
    ; Save stats (hunger, happiness, energy)
    mov al, [hunger_level]
    mov [edi], al
    inc edi
    
    mov al, [happiness_level]
    mov [edi], al
    inc edi
    
    mov al, [energy_level]
    mov [edi], al
    inc edi
    
    ; Save counters
    mov eax, [total_feedings]
    mov [edi], eax
    add edi, 4
    
    mov eax, [total_pettings]
    mov [edi], eax
    add edi, 4
    
    mov eax, [total_plays]
    mov [edi], eax
    add edi, 4
    
    mov eax, [total_insults]
    mov [edi], eax
    add edi, 4
    
    mov eax, [total_sleeps]
    mov [edi], eax
    add edi, 4
    
    mov eax, [pet_age]
    mov [edi], eax
    add edi, 4
    
    ; Save pet name length
    mov al, [pet_name_len]
    mov [edi], al
    inc edi
    
    ; Save pet name (up to 20 chars)
    movzx ecx, byte [pet_name_len]
    mov rsi, pet_name
    cld
    rep movsb
    
    ; Calculate total size
    mov r8, edi
    sub r8, save_buffer
    
    ; Write buffer to file
    mov rax, SYS_WRITE
    mov rdi, [save_file_handle]
    mov rsi, save_buffer
    mov rdx, r8
    syscall
    
    ; Close file
    mov rax, SYS_CLOSE
    mov rdi, [save_file_handle]
    syscall
    
    ; Show success message
    call clear_screen
    mov rsi, pet_save_msg
    mov rdx, pet_save_len
    call print_string
    
    call wait_for_key
    jmp main_loop
    
.save_error:
    call clear_screen
    mov rsi, pet_save_error
    mov rdx, pet_save_error_len
    call print_string
    
    call wait_for_key
    jmp main_loop

load_pet:
    ; Open file for reading
    mov rax, SYS_OPEN
    mov rdi, save_file_name
    mov rsi, O_RDONLY
    syscall
    
    ; Check for error
    cmp rax, 0
    jl .load_error
    
    ; Store file handle
    mov [save_file_handle], rax
    
    ; Read data from file
    mov rax, SYS_READ
    mov rdi, [save_file_handle]
    mov rsi, save_buffer
    mov rdx, 128            ; Max size of save data
    syscall
    
    ; Check if we read anything
    cmp rax, 10             ; Minimum valid save size
    jl .read_error
    
    ; Extract data from buffer
    mov edi, save_buffer
    
    ; Load pet type
    mov al, [edi]
    mov [pet_type], al
    inc edi
    
    ; Load mood
    mov al, [edi]
    mov [current_mood], al
    inc edi
    
    ; Load stats (hunger, happiness, energy)
    mov al, [edi]
    mov [hunger_level], al
    inc edi
    
    mov al, [edi]
    mov [happiness_level], al
    inc edi
    
    mov al, [edi]
    mov [energy_level], al
    inc edi
    
    ; Load counters
    mov eax, [edi]
    mov [total_feedings], eax
    add edi, 4
    
    mov eax, [edi]
    mov [total_pettings], eax
    add edi, 4
    
    mov eax, [edi]
    mov [total_plays], eax
    add edi, 4
    
    mov eax, [edi]
    mov [total_insults], eax
    add edi, 4
    
    mov eax, [edi]
    mov [total_sleeps], eax
    add edi, 4
    
    mov eax, [edi]
    mov [pet_age], eax
    add edi, 4
    
    ; Load pet name length
    mov al, [edi]
    mov [pet_name_len], al
    mov cl, al              ; Copy to CL for counter
    inc edi
    
    ; Load pet name (up to 20 chars)
    xor ch, ch              ; Clear high byte for ECX
    mov rsi, edi            ; Buffer position
    mov rdi, pet_name       ; Target
    cld
    rep movsb
    mov byte [pet_name + ecx], 0  ; NULL terminate
    
    ; Close file
    mov rax, SYS_CLOSE
    mov rdi, [save_file_handle]
    syscall
    
    ; Show success message
    call clear_screen
    mov rsi, pet_load_msg
    mov rdx, pet_load_len
    call print_string
    
    ; Update last interaction time
    mov rax, SYS_TIME
    mov rdi, 0
    syscall
    mov [last_interaction_time], rax
    
    call wait_for_key
    jmp main_loop

.read_error:
    ; Close file on error
    mov rax, SYS_CLOSE
    mov rdi, [save_file_handle]
    syscall
    
.load_error:
    ; Show error message
    call clear_screen
    mov rsi, pet_load_error
    mov rdx, pet_load_error_len
    call print_string
    
    call wait_for_key
    jmp main_loop

;--------------------------------
; Helper functions
;--------------------------------

; Update pet state based on time, hunger, energy levels
update_pet_state:
    ; Get current time
    mov rax, SYS_TIME
    mov rdi, 0
    syscall
    
    ; For animation - toggle frame on each call
    xor byte [animation_frame], 1
    
    ; Check if pet is sleeping - don't update stats if so
    cmp byte [current_mood], 4
    je .skip_stat_updates
    
    ; Increment tick counter
    inc byte [tick_counter]
    
    ; Every 5 ticks, update needs
    test byte [tick_counter], 3  ; Only update on multiples of 4
    jnz .no_needs_update
    
    ; Increase hunger
    mov al, [hunger_level]
    add al, 1
    cmp al, 100
    jle .store_hunger
    mov al, 100
.store_hunger:
    mov [hunger_level], al
    
    ; Decrease energy
    mov al, [energy_level]
    sub al, 1
    jns .store_energy
    mov al, 0
.store_energy:
    mov [energy_level], al
    
.no_needs_update:

    ; If time difference > 86400 (seconds in a day), increase age
    mov r8, rax                ; Current time
    sub r8, [last_interaction_time]
    cmp r8, 86400
    jl .no_age_update
    
    ; Adjust hunger and energy based on time too
    mov edx, 0                 ; Clear high bits
    mov rax, r8                ; Time difference
    mov rbx, 86400             ; Seconds in a day
    div rbx                    ; RAX = days elapsed
    
    ; Increase age by days elapsed
    add [pet_age], rax
    
    ; Reset last interaction time
    mov rax, SYS_TIME
    mov rdi, 0
    syscall
    mov [last_interaction_time], rax
    
.no_age_update:

.skip_stat_updates:
    ; Determine mood based on needs
    
    ; If sleeping, keep sleeping
    cmp byte [current_mood], 4
    je .done
    
    ; If hunger > 80, set mood to hungry
    mov al, [hunger_level]
    cmp al, 80
    jl .not_hungry
    mov byte [current_mood], 5  ; hungry
    jmp .done
    
.not_hungry:
    ; If energy < 20, set mood to sleepy
    mov al, [energy_level]
    cmp al, 20
    jg .not_sleepy
    mov byte [current_mood], 3  ; sleepy
    jmp .done
    
.not_sleepy:
    ; If happiness < 30, set mood to angry
    mov al, [happiness_level]
    cmp al, 30
    jg .not_angry
    mov byte [current_mood], 2  ; angry
    jmp .done
    
.not_angry:
    ; If happiness > 70, set mood to happy
    cmp al, 70
    jl .not_happy
    mov byte [current_mood], 1  ; happy
    jmp .done

.not_happy:
    ; Occasional random events (based on tick counter)
    test byte [tick_counter], 15  ; Only check on multiples of 16
    jnz .default_mood
    
    ; Randomly decide to trigger an event
    call random_number
    cmp al, 50                   ; 20% chance for event (51/256)
    jge .default_mood
    
    ; If event triggered, set wants_attention
    mov byte [current_mood], 6   ; wants_attention
    jmp .done

.default_mood:
    ; Default to idle mood
    mov byte [current_mood], 0   ; idle

.done:
    ret

; Display pet based on type and mood
display_pet:
    ; Check pet type
    cmp byte [pet_type], 1
    je .display_cat
    jmp .display_dog

.display_cat:
    ; Select cat display based on mood and animation frame
    cmp byte [current_mood], 0   ; idle
    jne .not_cat_idle
    
    ; For idle, select frame
    cmp byte [animation_frame], 0
    je .cat_idle_frame1
    
    mov rsi, cat_idle2
    mov rdx, cat_idle2_len
    jmp .print_pet
    
.cat_idle_frame1:
    mov rsi, cat_idle
    mov rdx, cat_idle_len
    jmp .print_pet
    
.not_cat_idle:
    cmp byte [current_mood], 1   ; happy
    jne .not_cat_happy
    
    ; For happy, select frame
    cmp byte [animation_frame], 0
    je .cat_happy_frame1
    
    mov rsi, cat_happy2
    mov rdx, cat_happy2_len
    jmp .print_pet
    
.cat_happy_frame1:
    mov rsi, cat_happy
    mov rdx, cat_happy_len
    jmp .print_pet
    
.not_cat_happy:
    cmp byte [current_mood], 2   ; angry
    jne .not_cat_angry
    
    ; For angry, select frame
    cmp byte [animation_frame], 0
    je .cat_angry_frame1
    
    mov rsi, cat_angry2
    mov rdx, cat_angry2_len
    jmp .print_pet
    
.cat_angry_frame1:
    mov rsi, cat_angry
    mov rdx, cat_angry_len
    jmp .print_pet
    
.not_cat_angry:
    cmp byte [current_mood], 3   ; sleepy
    jne .not_cat_sleepy
    
    mov rsi, cat_sleepy
    mov rdx, cat_sleepy_len
    jmp .print_pet
    
.not_cat_sleepy:
    cmp byte [current_mood], 4   ; sleeping
    jne .not_cat_sleeping
    
    ; For sleeping, select frame
    cmp byte [animation_frame], 0
    je .cat_sleeping_frame1
    
    mov rsi, cat_sleeping2
    mov rdx, cat_sleeping2_len
    jmp .print_pet
    
.cat_sleeping_frame1:
    mov rsi, cat_sleeping
    mov rdx, cat_sleeping_len
    jmp .print_pet
    
.not_cat_sleeping:
    cmp byte [current_mood], 5   ; hungry
    jne .not_cat_hungry
    
    ; For hungry, select frame
    cmp byte [animation_frame], 0
    je .cat_hungry_frame1
    
    mov rsi, cat_hungry2
    mov rdx, cat_hungry2_len
    jmp .print_pet
    
.cat_hungry_frame1:
    mov rsi, cat_hungry
    mov rdx, cat_hungry_len
    jmp .print_pet
    
.not_cat_hungry:
    cmp byte [current_mood], 6   ; want attention
    jne .cat_default
    
    ; For want attention, select frame
    cmp byte [animation_frame], 0
    je .cat_want_attention_frame1
    
    mov rsi, cat_want_attention2
    mov rdx, cat_want_attention2_len
    jmp .print_pet
    
.cat_want_attention_frame1:
    mov rsi, cat_want_attention
    mov rdx, cat_want_attention_len
    jmp .print_pet
    
.cat_default:
    ; Default to idle
    mov rsi, cat_idle
    mov rdx, cat_idle_len
    jmp .print_pet

.display_dog:
    ; Select dog display based on mood and animation frame
    cmp byte [current_mood], 0   ; idle
    jne .not_dog_idle
    
    ; For idle, select frame
    cmp byte [animation_frame], 0
    je .dog_idle_frame1
    
    mov rsi, dog_idle2
    mov rdx, dog_idle2_len
    jmp .print_pet
    
.dog_idle_frame1:
    mov rsi, dog_idle
    mov rdx, dog_idle_len
    jmp .print_pet
    
.not_dog_idle:
    cmp byte [current_mood], 1   ; happy
    jne .not_dog_happy
    
    ; For happy, select frame
    cmp byte [animation_frame], 0
    je .dog_happy_frame1
    
    mov rsi, dog_happy2
    mov rdx, dog_happy2_len
    jmp .print_pet
    
.dog_happy_frame1:
    mov rsi, dog_happy
    mov rdx, dog_happy_len
    jmp .print_pet
    
.not_dog_happy:
    cmp byte [current_mood], 2   ; angry
    jne .not_dog_angry
    
    ; For angry, select frame
    cmp byte [animation_frame], 0
    je .dog_angry_frame1
    
    mov rsi, dog_angry2
    mov rdx, dog_angry2_len
    jmp .print_pet
    
.dog_angry_frame1:
    mov rsi, dog_angry
    mov rdx, dog_angry_len
    jmp .print_pet
    
.not_dog_angry:
    cmp byte [current_mood], 3   ; sleepy
    jne .not_dog_sleepy
    
    mov rsi, dog_sleepy
    mov rdx, dog_sleepy_len
    jmp .print_pet
    
.not_dog_sleepy:
    cmp byte [current_mood], 4   ; sleeping
    jne .not_dog_sleeping
    
    ; For sleeping, select frame
    cmp byte [animation_frame], 0
    je .dog_sleeping_frame1
    
    mov rsi, dog_sleeping2
    mov rdx, dog_sleeping2_len
    jmp .print_pet
    
.dog_sleeping_frame1:
    mov rsi, dog_sleeping
    mov rdx, dog_sleeping_len
    jmp .print_pet
    
.not_dog_sleeping:
    cmp byte [current_mood], 5   ; hungry
    jne .not_dog_hungry
    
    ; For hungry, select frame
    cmp byte [animation_frame], 0
    je .dog_hungry_frame1
    
    mov rsi, dog_hungry2
    mov rdx, dog_hungry2_len
    jmp .print_pet
    
.dog_hungry_frame1:
    mov rsi, dog_hungry
    mov rdx, dog_hungry_len
    jmp .print_pet
    
.not_dog_hungry:
    cmp byte [current_mood], 6   ; want attention
    jne .dog_default
    
    ; For want attention, select frame
    cmp byte [animation_frame], 0
    je .dog_want_attention_frame1
    
    mov rsi, dog_want_attention2
    mov rdx, dog_want_attention2_len
    jmp .print_pet
    
.dog_want_attention_frame1:
    mov rsi, dog_want_attention
    mov rdx, dog_want_attention_len
    jmp .print_pet
    
.dog_default:
    ; Default to idle
    mov rsi, dog_idle
    mov rdx, dog_idle_len
    
.print_pet:
    ; Print the selected pet graphic
    call print_string
    
    ; Print pet name
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, pet_name
    movzx rdx, byte [pet_name_len]
    syscall
    
    ; Print newline
    call print_newline
    call print_newline
    
    ret

; Generate a pseudo-random number (0-255) in AL
random_number:
    ; Simple LFSR-like algorithm
    inc dword [random_counter]
    mov eax, [random_counter]
    xor eax, 0xdeadbeef
    mov ecx, eax
    shl eax, 13
    xor eax, ecx
    mov ecx, eax
    shr eax, 17
    xor eax, ecx
    mov ecx, eax
    shl eax, 5
    xor eax, ecx
    and eax, 0xff  ; Return 0-255 only
    ret

; Print string in RSI with length in RDX
print_string:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    syscall
    ret

; Print a newline
print_newline:
    push rsi
    push rdx
    
    mov rsi, LF
    lea rdx, [rsi]  ; Set length to 1
    call print_string
    
    pop rdx
    pop rsi
    ret

; Get a single keypress (no echo)
get_single_key:
    ; Read a single character
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, input_char
    mov rdx, 1
    syscall
    ret

; Wait for a keypress
wait_for_key:
    ; Display prompt
    mov rsi, press_any_key
    mov rdx, press_any_key_len
    call print_string
    
    ; Get a key
    call get_single_key
    ret

; Clear the screen
clear_screen:
    ; Write ANSI escape sequence to clear screen
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, clear_screen_seq
    mov rdx, clear_screen_len
    syscall
    ret

; Print a number in RAX (simple decimal conversion)
print_number:
    ; Convert number to ASCII
    mov rsi, num_buffer + 9  ; Start at end of buffer
    mov rbx, 10              ; Divisor
    mov rcx, 0               ; Digit counter
    
    ; Special case for zero
    test rax, rax
    jnz .convert_loop
    
    mov byte [rsi], '0'
    inc rcx
    jmp .print_digits
    
.convert_loop:
    test rax, rax
    jz .print_digits
    
    ; Divide by 10
    mov rdx, 0
    div rbx
    
    ; Convert remainder to ASCII and store
    add dl, '0'
    dec rsi
    mov [rsi], dl
    
    ; Count digits
    inc rcx
    
    jmp .convert_loop
    
.print_digits:
    ; Print the digits
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rdx, rcx  ; Number of digits to print
    syscall
    ret

exit_program:
    ; Exit the program
    mov rax, SYS_EXIT
    mov rdi, 0       ; Return 0 status
    syscall