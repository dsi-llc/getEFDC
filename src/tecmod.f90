MODULE TECMOD
! ** AUTHOR: DH CHUNG

USE GLOBALVARS
IMPLICIT NONE

CONTAINS
SUBROUTINE TECPLOT(TIMESTEP,OPT,FIRSTTIME)
  INTEGER(4),INTENT(IN)::OPT,FIRSTTIME
  REAL(4)   ,INTENT(IN)::TIMESTEP
  REAL(4)::MAG,BLK0
  INTEGER(4),SAVE::NT
  INTEGER(4)::I,J,L,NW,UOUT,N1,KK,IKB
  CHARACTER(200)::STR,STR1*10,STR2*10,STR3*12

  BLK0=-999
  !*** FIRST CALL
  IF(FIRSTTIME==1)THEN
    IF (OPT==1) THEN
 	    OPEN (UTEC1,FILE='#output\RESULT\DEP_TEC.PLT')
	    WRITE(UTEC1,'(A)')'TITLE = "EFDC WATER DEPTH"'
	    WRITE(UTEC1,'(A)')'VARIABLES="X","Y","DEPTH","BOTTOM"' 
      NT=0
    ELSEIF (OPT==11) THEN
 	    OPEN (UTEC5,FILE='#output\RESULT\NLAYERS_TEC.PLT')
	    WRITE(UTEC5,'(A)')'TITLE = "SIGMMA-ZED LAYER MAP"'
	    WRITE(UTEC5,'(A)')'VARIABLES="X","Y","LAYERS"'      
    ELSEIF (OPT==2) THEN
	    OPEN (UTEC2,FILE='#output\RESULT\VEL_TEC_K_'//TRIM(SSTR2)//'.PLT')
	    WRITE(UTEC2,'(A)')'TITLE = "EFDC HYDRODYNAMICS"'
	    WRITE(UTEC2,'(A)')'VARIABLES="X","Y","U","V","MAG"' 
	  ELSEIF (OPT==21) THEN
	    OPEN (UTEC2,FILE='#output\RESULT\VEL_TEC_K_0.PLT')
	    WRITE(UTEC2,'(A)')'TITLE = "EFDC HYDRODYNAMICS : DEPTH-AVERAGE"'
	    WRITE(UTEC2,'(A)')'VARIABLES="X","Y","UA","VA","MAGA"' 
	  ELSEIF(OPT==3) THEN
	    OPEN (UTEC3,FILE='#output\RESULT\WC_TEC_K_'//TRIM(SSTR2)//'.PLT')
	    WRITE(UTEC3,'(A)')'TITLE = "EFDC WC DATA"'
	    WRITE(UTEC3,'(A)')'VARIABLES="X","Y","SAL","TEM","DYE","TOX","SED","SND"' 
	  
	  ELSEIF(OPT==31) THEN
	    OPEN (UTEC3,FILE='#output\RESULT\WC_TEC_K_0.PLT')
	    WRITE(UTEC3,'(A)')'TITLE = "EFDC WC DATA : DEPTH-AVERAGE"'
	    WRITE(UTEC3,'(A)')'VARIABLES="X","Y","SALA","TEMA","DYEA","TOXA","SEDA","SNDA"' 
	    
    ELSEIF(OPT==4) THEN
	    OPEN (UTEC4,FILE='#output\RESULT\WQ_TEC_K_'//TRIM(SSTR2)//'.PLT')
	    WRITE(UTEC4,'(A)')'TITLE = "EFDC WQ Data"'
	    WRITE(UTEC4,'(A)')'VARIABLES="X","Y","CHC","CHD","CHG","ROC","LOC","DOC","ROP","LOP","DOP","P4D","RON","LON","DON","NHX","NOX","SUU","SAA","COD","DOX","TAM","FCB"' 
	  
	  ELSEIF(OPT==41) THEN
	    OPEN (UTEC4,FILE='#output\RESULT\WQ_TEC_K_0.PLT')
	    WRITE(UTEC4,'(A)')'TITLE = "EFDC WQ Data : DEPTH-AVERAG"'
	    WRITE(UTEC4,'(A)')'VARIABLES="X","Y","CHC","CHD","CHG","ROC","LOC","DOC","ROP","LOP","DOP","P4D","RON","LON","DON","NHX","NOX","SUU","SAA","COD","DOX","TAM","FCB"' 
     
    ELSEIF(OPT==5) THEN
	    OPEN (UTEC6,FILE='#output\RESULT\BED_TEC_K_'//TRIM(SSTR2)//'.PLT')
	    WRITE(UTEC6,'(A)')'TITLE = "EFDC BED DATA"'
	    WRITE(UTEC6,'(A)')'VARIABLES="X","Y","KBT","HBED","BDELTA","BDENBED","PORBED","SEDB","SNDB","TOXB"' 
	  
	  ELSEIF(OPT==51) THEN
	    OPEN (UTEC6,FILE='#output\RESULT\BED_TEC_K_0.PLT')
	    WRITE(UTEC6,'(A)')'TITLE = "EFDC BED DATA : DEPTH-AVERAGE"'
	    WRITE(UTEC6,'(A)')'VARIABLES="X","Y","KBT","HBED","BDELTA","BDENBED","PORBED","SEDB","SNDB","TOXB"' 
        ENDIF
	  RETURN
  ENDIF
  
  !*** NEXT CALL
  WRITE(STR1,'(I6)') 4*(LA-1)
  WRITE(STR2,'(I8)') LA-1
  WRITE(STR3,'(F12.4)') TIMESTEP
  STR = 'ZONE N='//TRIM(STR1)//', E='//TRIM(STR2)//', F=FEPOINT, ET=QUADRILATERAL, T="'//TRIM(STR3)//'"'

  IF (OPT==1) THEN
    UOUT = UTEC1
    NT=NT+1
  ELSEIF (OPT==11) THEN
    UOUT = UTEC5
  ELSEIF (OPT==2.OR.OPT==21) THEN
    UOUT = UTEC2
  ELSEIF (OPT==3.OR.OPT==31) THEN
    UOUT = UTEC3
  ELSEIF (OPT==4.OR.OPT==41) THEN
    UOUT = UTEC4
  ELSEIF (OPT==5.OR.OPT==51) THEN
    UOUT = UTEC6
  ENDIF  
  WRITE(UOUT,'(A)') STR

  DO L=2,LA
    IF (IGRIDV>0.AND.LAYK==1) THEN
      KK = KSZ(L)
    ELSE
      KK = LAYK
    ENDIF
    IF (LAYK<0) IKB=0
    IF (LAYK>KB) IKB=KB
    IF (LAYK>=0.OR.LAYK<=KB) THEN      
      IKB = LAYK
    ENDIF
    IF (OPT==1) THEN 
      DO I=1,4
        WRITE(UTEC1,'(2F12.2,2F10.3)') XCOR(L,I),YCOR(L,I),HPT(L,NT),BELV(L)
      ENDDO
    ELSEIF (OPT==11) THEN 
      DO I=1,4
        WRITE(UTEC5,'(2F12.2,I8)') XCOR(L,I),YCOR(L,I),KC-KSZ(L)+1
      ENDDO
    ELSEIF (OPT==2) THEN 
      MAG=SQRT((UK(L,KK))**2+(VK(L,KK))**2)
      WRITE(UTEC2,'(2F12.2,3F10.3)') XCOR(L,1),YCOR(L,1),UK(L,KK),VK(L,KK),MAG
      DO I=2,4
        WRITE(UTEC2,'(2F12.2,3F10.3)') XCOR(L,I),YCOR(L,I),0.,0.,0.
      ENDDO
    ELSEIF (OPT==21) THEN 
      MAG=SQRT(UA(L)**2+VA(L)**2)
      WRITE(UTEC2,'(2F12.2,3F10.3)') XCOR(L,1),YCOR(L,1),UA(L),VA(L),MAG
      DO I=2,4
        WRITE(UTEC2,'(2F12.2,3F10.3)') XCOR(L,I),YCOR(L,I),0.,0.,0.
      ENDDO
    ELSEIF(OPT==3) THEN
      DO I=1,4
        WRITE(UTEC3,'(2F12.2,6F10.3)') XCOR(L,I),YCOR(L,I),SAL(L,KK),TEM(L,KK),DYE(L,KK),TOX(L,KK,1),SED(L,KK,1),SND(L,KK,1)
      ENDDO
    ELSEIF(OPT==31) THEN
      DO I=1,4
        WRITE(UTEC3,'(2F12.2,6F10.3)') XCOR(L,I),YCOR(L,I),SALA(L),TEMA(L),DYEA(L),TOXA(L,1),SEDA(L,1),SNDA(L,1)
      ENDDO
    ELSEIF(OPT==4) THEN
      DO I=1,4
        WRITE(UTEC4,'(2F12.2,21F10.3)') XCOR(L,I),YCOR(L,I),(WQV(L,KK,NW),NW=1,21)
      ENDDO    
    ELSEIF(OPT==41) THEN
      DO I=1,4
        WRITE(UTEC4,'(2F12.2,21F10.3)') XCOR(L,I),YCOR(L,I),(WQVA(L,NW),NW=1,21)
      ENDDO
    ELSEIF(OPT==5) THEN
        !	    WRITE(UTEC6,'(A)')'VARIABLES="X","Y","KBT","HBED","BDELTA","BDENBED","PORBED","SEDB","SNDB","TOXB"' 
      DO I=1,4
        WRITE(UTEC6,'(2F12.2,7F15.3)') XCOR(L,I),YCOR(L,I),KBT(L),HBED(L,IKB),BDELTA(L,IKB),PORBED(L,IKB),SEDB(L,IKB,1),SNDB(L,IKB,1),TOXB(L,IKB,1)
      ENDDO    
    !ELSEIF(OPT==51) THEN
    !  DO I=1,4
    !    WRITE(UTEC6,'(2F12.2,21F10.3)') XCOR(L,I),YCOR(L,I),(WQVA(L,NW),NW=1,21)
    !  ENDDO
    ENDIF    
  ENDDO
  N1=0
  DO L=2,LA
    WRITE(UOUT,'(4I6)') (N1+I,I=1,4)
    N1=N1+4
  ENDDO
 
END SUBROUTINE 

SUBROUTINE TECPLOT_TMP(TIMESTEP,FIRSTTIME,OP)
  INTEGER(4),INTENT(IN)::FIRSTTIME
  INTEGER(4),OPTIONAL  ::OP
  REAL(4)   ,INTENT(IN)::TIMESTEP
  INTEGER(4)::I,J,L,NW,UOUT,N1,KK
  CHARACTER(200)::STR,STR1*10,STR2*10,STR3*12

  !*** FIRST CALL
  IF(FIRSTTIME==1)THEN
    IF (PRESENT(OP)) THEN
      OPEN (UTEC1,FILE='#output\RESULT\TMP.PLT')
    ELSE
      OPEN (UTEC1,FILE='#output\RESULT\ARR.PLT')
    ENDIF
    
    WRITE(UTEC1,'(A)')'TITLE = "TMP FILE"'
    WRITE(UTEC1,'(A)')'VARIABLES="X","Y","ARR"' 
    RETURN
  ENDIF
  
  !*** NEXT CALL
  WRITE(STR1,'(I6)') 4*(LA-1)
  WRITE(STR2,'(I8)') LA-1
  WRITE(STR3,'(F12.5)') TIMESTEP
  STR = 'ZONE N='//TRIM(STR1)//', E='//TRIM(STR2)//', F=FEPOINT, ET=QUADRILATERAL, T="'//TRIM(STR3)//'"'
  WRITE(UTEC1,'(A)') STR

  DO L=2,LA
    IF (IGRIDV>0.AND.LAYK==1) THEN
      KK = KSZ(L)
    ELSE
      KK = LAYK
    ENDIF

    DO I=1,4
      WRITE(UTEC1,'(2F12.2,E10.3)') XCOR(L,I),YCOR(L,I),ARR(L)
    ENDDO
     
  ENDDO
  N1=0
  DO L=2,LA
    WRITE(UTEC1,'(4I6)') (N1+I,I=1,4)
    N1=N1+4
  ENDDO
 
END SUBROUTINE 

END MODULE
