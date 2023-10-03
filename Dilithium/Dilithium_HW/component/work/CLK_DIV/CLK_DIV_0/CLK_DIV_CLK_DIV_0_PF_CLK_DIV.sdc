set_component CLK_DIV_CLK_DIV_0_PF_CLK_DIV
create_generated_clock -source [ get_pins I_CD/A ] -multiply_by 1 -divide_by 2 [ get_pins I_CD/Y_DIV ]
