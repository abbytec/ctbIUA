
.text
.align 2
.global miMain
.type miMain, %function
.extern printf
.extern nave
// .extern arbol

player:
    .word   20  // X
    .word   20  // y
    


miMain: // X0 pixels
		mov		x10, x0	     	//  BackUp pixels address
		mov		x15, x1	     	//  BackUp config

		// adrp	X7, contador	// Variable contador
		// add		X7, X7, :lo12:contador

		
		//ldr		X11, [X7, #0]
        mov x11, 0xfff
        mov x12, 0xfff
loop2:
//  Pinto pantalla de color
		mov     x0, x10
		movz	w1, 0xffff
		movk	w1, 0xffff, lsl 16	// X2 = color
        bl      pintar_pantalla_color

// Dibujo Imagen
		mov     x0, x10       // pantalla
        adrp	x1, arbol	  // Variable arbol
		add		x1, x1, :lo12:arbol
		mov     x3, x11
		movz    x2, 10
		bl      draw_image
		
// Dibujo Imagen
		mov     x0, x10       // pantalla
        adrp	x1, arbol	  // Variable arbol
		add		x1, x1, :lo12:arbol
		mov     x3, x12
		movz    x2, 10
		bl      draw_image
		
		add     x12, x12 ,#16
		
        ldrb	w7, [x15, #0]
		subs	wzr, w7, #1
        b.ne	ver_der		
		sub     x11, x11 ,#16
		b        wait	
ver_der:
        ldrb	w7, [x15, #1]
		subs	wzr, w7, #1
        b.ne	wait		
		add     x11, x11 ,#16


wait: 	// wait for frame

        ldrb	w7, [x15, #8]
		subs	wzr, w7, #1
        b.ne	wait
		mov		w7, #0
		strb	w7,[x15, #8]
		b		loop2
		
		
pintar_pantalla_color:
        sub     sp, sp ,48
        str     x29,[sp, 40]
        str     x30,[sp, 32]
        str     x2,[sp, 24]
        str     x3,[sp, 16]
        str     x4,[sp, 8]
        str     x5,[sp, 0]
        
		mov		x2,	#0			//	Start counter in 0

pintar_pantalla_color_loop:

		add		x3, x0, x2
		adrp	x1, escenario	  // Variable arbol
		add		x1, x1, :lo12:escenario
		add     x1, x1, x2
		str		w1, [x3, #0]

		add		x2, x2, #4
		movz	x4,	0xB000       // 0x4b000
		movk	x4, 0x4, lsl 16
		cmp		x2, x4
		b.lt	pintar_pantalla_color_loop
		
        ldr     x5,[sp, 0]
        ldr     x4,[sp, 8]
        ldr     x3,[sp, 16]
        ldr     x2,[sp, 24]
        ldr     x30,[sp, 32]
        ldr     x29,[sp, 40]
        add     sp, sp ,48
		ret

/*
    X0  direccion de pintar_pantalla_color
    X1  direccion de imagen
    x2  fila
    X3  columna
*/

draw_image:
        sub     sp, sp ,48
        str     x29,[sp, 40]
        str     x30,[sp, 32]
        str     x4,[sp, 24]
        str     x5,[sp, 16]
        str     x6,[sp, 8]
        str     x7,[sp, 0]
        
        // Mover puntero de pantalla al primer pixel donde debe ir la imagen.
        movz    x4, #1280
        mul     x2, x2, x4 // 320 x 4
        add     x0, x0, x2
        lsl     x3, x3, #2
        add     x0, x0, x3
        
        
        ldr     x2, [x1, #0]    // x4 Ancho
        ldr     x3, [x1, #8]    // x5 Alto
        add     x1, x1, #16
        
		mov		x4,	#0			// Cont Filas de imagen
		mov		x5,	#0			// Cont Columnas de imagen
		
		
        
draw_image_loop:

        ldr     w6, [x1,#0]
        lsr     w7, w6, #24         // 0xff aabbcc
        cmp     w7, 0xff          //  ( Red * A + Pix *(256-A) ) / 256
        b.lt    no_dibujar
		str		w6, [x0, #0]
no_dibujar:
		add     x0, x0, #4        // Muevo direccion del pixel de pantalla
		add     x1, x1, #4        // Muevo direccion del pixel de imagen
		add     x5, x5, #1        // Incremento en uno la columna
		cmp     x5, x2
		b.lt   draw_image_loop   // Estoy dibujando una fila 
		
		mov		x5,	#0			// Columna de nuevo 0
		add     x0, x0, #1280
		lsl     x6, x2, #2
		sub     x0, x0 , x6
		
		add     x4, x4, #1
		cmp     x4, x3
		b.lt   draw_image_loop   // Paso a la siguiente fila.
		

		ldr     x7,[sp, 0]
        ldr     x6,[sp, 8]
        ldr     x5,[sp, 16]
        ldr     x4,[sp, 24]
        ldr     x30,[sp, 32]
        ldr     x29,[sp, 40]
        add     sp, sp ,48
		ret
