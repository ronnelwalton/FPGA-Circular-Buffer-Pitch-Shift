-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\pitchShift\modimpl_ntwk_block.vhd
-- Created: 2022-05-07 23:06:07
-- 
-- Generated by MATLAB 9.12 and HDL Coder 3.20
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: modimpl_ntwk_block
-- Source Path: pitchShift/pitchShift/modimpl_ntwk
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY modimpl_ntwk_block IS
  PORT( X                                 :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        Y                                 :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
        );
END modimpl_ntwk_block;


ARCHITECTURE rtl OF modimpl_ntwk_block IS

BEGIN
  -- cgireml component
  Y <= X;

END rtl;
