#include "fivewin.ch"
#include "DtPicker.ch"
#include "FastRepH.ch"
/*
Controle de Despesas e Receitas
*/

REQUEST HB_Lang_PT
REQUEST HB_CODEPAGE_DE850, HB_CODEPAGE_DEISO
Function Main()
   Public vlogoemp
   HB_LANGSELECT( 'PT' ) // Default language is now Portuguese
   sethandlecount(250)
   SetBalloon( .T. )
   SET DELE ON
   SET CENT ON
   SET DATE BRIT
   SET EPOCH TO 1980
   SET MULTIPLE ON
   *
   SET 3DLOOK ON
   SET SOFTSEEK OFF
   SET CONFIRM ON
   *
   REQUEST DBFCDX
   RDDSETDEFAULT("DBFCDX")
   hBorland := LoadLibrary( ".\dll\bwcc32.dll" )
   hBorland := LoadLibrary( ".\dll\prev32.dll" )
   hBorland := LoadLibrary( ".\dll\freeimage.dll" )
   hBorland := LoadLibrary( ".\dll\FrSystH.dll" )

   Define Icon oIco Resource "EST"
   MsgRun("AGUARDE ... CRIANDO BANCO DE DADOS ...","... AGUARDE ...",{|oDlgRun|Est1DbfCria()})
   MsgRun("AGUARDE ... CRIANDO INDICES DOS BANCOS ...","... AGUARDE ...",{|oDlgRun|Est1Reorgaz()})


   Use Empresa alias emp shared new
   if NetErr()
      MsgInfo("Arquivo Aberto em Modo Exclusivo - Empresas","Informação")
      close data
      return .f.
   endif

   Use usuario alias usu shared new
   if NetErr()
      MsgInfo("Arquivo Aberto em Modo Exclusivo - Usuario","Informação")
      close data
      return .f.
   endif
   set index to usuario

   lFaz:=.f.
   Select Emp
   If Eof()
      DadosEMpresa()
   endif


   vlogoemp:= emp->logoemp
   if empty(vlogoemp)
      vlogoemp:=  CurDrive()+":\"+ CurDir()+"\bmp\logoemp.bmp"
   endif


   vNomeusu:= space(len( usu->nomeusu))
   vsenhusu:= space(len( usu->senhusu))
   Define Font oFontSis Name "Segoe UI" Size 35,50 Bold
   Define Font oFontSi1 Name "Segoe UI" Size 10,15
   Define Font oFontSay Name "Segoe UI" Size 15,15
   Define Font oFontget Name "Segoe UI" Size 10,15

   Define Dialog oDlgEst1 Resource "EST1_ABER" Title "Abertura - Controle de Despesas e Receitas" ICON oIco //TRANSPARENT COLOR CLR_BLACK,CLR_WHITE


   REDEFINE IMAGE oiLogoemp ID 4001 OF oDlgEst1 FILENAME vlogoemp Border

   redefine Say osisnome var "Cedro" id 4009 of oDlgEst1 font oFontSis Color CLR_BROWN
   REDEFINE SAY osisnom1 var "Controle de Despesas e Receitas®"  id 4010 of oDlgEst1
   redefine say osusuari var "Usuário:" id 4002 of oDlgEst1 Font oFontSay
   redefine say ossenhaa var "Senha:" id 4003 of oDlgEst1 Font oFontSay

   Redefine get onomeusu var vnomeusu id 4004 of oDlgEst1 font oFontget valid ! Empty(vnomeusu)
   Redefine get osenhusu var vsenhusu id 4005 of oDlgEst1 font oFontget valid ! EMpty(vsenhusu)

   REDEFINE BUTTONbmp ID 999 OF oDlgEst1 ACTION (DadosEMpresa(),oiLogoemp:LoadBmp(vlogoemp),oiLogoemp:Refresh())  bitmap "EMP" ADJUST  tOOLTIP "Alterar Dados da Empresa" Cancel

   REDEFINE BUTTON ID 4006 OF oDlgEst1 ACTION (lFaz:=.t.,oDlgEst1:End())
   REDEFINE BUTTON ID 4007 OF oDlgEst1 ACTION (lFaz:=.f.,oDlgEst1:End()) cancel

   Activate Dialog oDlgEst1 Centered valid if (lFaz,Est1CheckUsuSen(oNomeUsu,oSenhUsu,@vNomeusu,@vSenhusu),.t.)


   if lFaz
      Est1Estoque()
   endif
   Release All
Function Est1Estoque

   use receita alias rec shared new
   if NetErr()
      MsgInfo("Arquivo Aberto em Modo Exclusivo - Receita","Informação")
      close data
      return .f.
   endif
   set index to receita
   Select rec
   set order to 2
   go top

   Define Icon oIco Resource "EST"
   Define Font oFontSis Name "Segoe UI" Size 16,50 Bold
   Define Font oFontSi1 Name "Segoe UI" Size 10,15
   Define Dialog oDlgEst12 Resource "EST1_MAIN1" TITLE "Controle de Despesas e Receitas" Icon oIco
   REDEFINE IMAGE oLogoemp ID 4001 OF oDlgEst12 FILENAME vlogoemp adjust

   redefine Say osisnome var "    Controle De Despesas e Receitas" id 4002 of oDlgEst12 font oFontSis Color CLR_RED
   oLbxdr:= TxBrowse():New( oDlgEst12 )
   oLbxdr:CreateFromResource( 101 )
   oLbxdr:cAlias:= 'rec'


   ADD COLUMN oCol1 TO XBROWSE oLbxdr HEADER "Data"        DATA REC->DATAREC SIZE 110
   ADD COLUMN oCol2 TO XBROWSE oLbxdr HEADER "Descrição" DATA REC->DESCREC SIZE 325
   ADD COLUMN oCol3 TO XBROWSE oLbxdr HEADER "Parc." DATA alltrim(PARCNUM+"/"+PARCREC)  SIZE 60
   ADD COLUMN oCol4 TO XBROWSE oLbxdr HEADER "Valor" DATA REC->VALOREC SIZE 150

   oCol1:nHeadStrAlign:=1;oCol1:nDataStrAlign:=1
    oCol2:nHeadStrAlign:=0;oCol2:nDataStrAlign:=0
    oCol3:nHeadStrAlign:=0;oCol3:nDataStrAlign:=0
    oCol4:nHeadStrAlign:=1;oCol4:nDataStrAlign:=1
    oLbxdr:oFont:= oFontSi1
   oLbxdr:aCols[ 1 ]:bLClickHeader := {||rec->(DbSetOrder(1)) ,rec->(DbGoTop()),oLbxdr:Refresh()}
   oLbxdr:bClrStd         := { ||{ IF( rec->TIPOREC = "E" , CLR_GREEN, CLR_HRED ),CLR_WHITE   } }
   oLbxdr:lHeader 		    := .T.
   oLbxdr:lHScroll        := .F.
   oLbxdr:lVScroll        := .F.
   oLbxdr:nMarqueeStyle   :=  5
   oLbxdr:lRecordSelector := .F.
   oLbxdr:lUpdate         := .T.
   oLbxdr:nColDividerStyle := oLbxdr:nRowDividerStyle       := LINESTYLE_NOLINES
   oLbxdr:lColDividerComplete := .F.
   oLbxdr:nMarqueeStyle:=7
   
   REDEFINE BUTTONBMP botao1 ID 4003 OF oDlgEst12 ;
    ACTION (Est1Inc(oLbxdr,.t.,"E"),oLbxdr:Refresh(),xsetfocus(oLbxdr)) ;
    PROMPT "&1.Receita" Bitmap "REC1" ADJUST TEXTBOTTOM
    
   REDEFINE BUTTONBMP botao2 ID 4010 OF oDlgEst12 ;
    ACTION (Est1Inc(oLbxdr,.t.,"S"),oLbxdr:Refresh(),xsetfocus(oLbxdr)) ;
    PROMPT "&2.Despesas" Bitmap "DES2" ADJUST TEXTBOTTOM
    
   REDEFINE BUTTONBMP botao3 ID 4004 OF oDlgEst12 ;
    ACTION (Est1Inc(oLbxdr,.F.),oLbxdr:Refresh(),xsetfocus(oLbxdr)) ;
    PROMPT "&3.Alterar" Bitmap "ALT3" ADJUST TEXTBOTTOM
    
   REDEFINE BUTTONBMP botao4 ID 4006 OF oDlgEst12 ;
    ACTION (Est1Exc(oLbxdr),oLbxdr:Refresh(),xsetfocus(oLbxdr)) ;
    PROMPT "&4.Excluir" Bitmap "EXC4" ADJUST TEXTBOTTOM

   REDEFINE BUTTONBMP botao5 ID 4007 OF oDlgEst12 ;
    ACTION (MenuRelatorios(botao5),oLbxdr:Refresh(),xsetfocus(oLbxdr)) ;
    PROMPT "&5.Relatorios" Bitmap "IMP5" ADJUST TEXTBOTTOM Tooltip "Resumo Mensal das Entradas ."

   REDEFINE BUTTONBMP botao6 ID 4008 OF oDlgEst12 ;
    ACTION (Est1CadUsu(),oLbxdr:Refresh(),xsetfocus(oLbxdr)) ;
    PROMPT "&6. Usuarios" Bitmap "IMP6" ADJUST TEXTBOTTOM  Tooltip "Resumo Anual das Entradas ."

   REDEFINE BUTTONBMP botao7 ID 4009 OF oDlgEst12 ;
    ACTION oDlgEst12:End() PROMPT "&7.Sair" Bitmap "SAI7" ADJUST TEXTBOTTOM

   Redefine BUTTON botao8 id 4005 of odlgest12 Action (Filtrar(),oLbxdr:Refresh(),xsetfocus(oLbxdr))    Prompt "&Filtrar"
   Redefine BUTTON botao9 id 4011 of odlgest12 Action (Pesquis(),oLbxdr:Refresh(),xsetfocus(oLbxdr))    Prompt "&Pesquisa"

   oDlgEst12:bStart:= {|| SKIN( oDlgEst12, "blue_skin" ) }

   ACTIVATE Dialog oDlgEst12 Centered
Function Pesquis()
    Local cData:=ctod("")
    Select rec

    if MsgGet("Pesquisa de Data","Informe a Data:",@cData)
       Locate For rec->datarec=cdata
    endif




Function Filtrar()
    Local cData:="  /    "
    Select rec
    if MsgGet("Filtro de Data","Informe o Mes e o Ano Ex:12/2013",@cData)
       set filter to SubStr(  dtoc(REC->DATAREC),4,7)=cdata
    else
       set filter to
    endif
    go top
    


Function MenuRelatorios(botao5)

   MENU oPopupUSU POPUP 2007
   *
   MenuItem "&1.R. Mensal "  			Action  Est1EntradasGeral(1)
   MenuItem "&2.R. Anual"  			Action  Est1ResumoLancamentos()
   MenuItem "&3.R. Entradas Geral"  Action  Est1EntradasGeral(2)
   MenuItem "&4.R. Saidas Geral"  	Action  Est1EntradasGeral(3)
   *
   ENDMENU
   ACTIVATE POPUP oPopupUSU OF botao5

Function Est1CadUsu

Function Est1EntradasGeral(tipo)
   Public aItensRec:={{},{},{},{},{},{}},I:=1
   Select Emp
   vNOMEEMP:=alltrim(emp->NOMEEMP)
   vENDEEMP:=alltrim(emp->ENDEEMP)
   vNUMEEMP:=alltrim(emp->NUMEEMP)
   vBAIREMP:=alltrim(emp->BAIREMP)
   vCIDAEMP:=alltrim(emp->CIDAEMP)
   vUFEMPRE:=alltrim(emp->UFEMPRE)
   vCEPEMPR:=alltrim(emp->CEPEMPR)
   vCNPJEMP:=alltrim(emp->CNPJEMP)
   vTELEEMP:=alltrim(emp->TELEEMP)
   vATIVEMP:=alltrim(emp->ATIVEMP)
   vEMAIEMP:=alltrim(emp->EMAIEMP)
   vSITEEMP:=alltrim(emp->SITEEMP)
   vlogoemp:=alltrim(vlogoemp)

   vReceitas:=0.00
   vDespesas:=0.00
   vRendimen:=0.00
   vrodape:=""
   Do Case
   Case tipo=1
      Select rec
      vdatarec:=rec->datarec
      Set order to 6
      Set SoftSeek On
      vtituloo:=  ("Relatório do Mes: "+strzero( Month(vdatarec),2,0)+" - "+ CMonth(vdatarec))
      vdataini:= ctod("01"+substr(dtoc(vdatarec),3,8))
      Seek vdataini
      vdatafim:= ctod("01/"+strzero((val(substr(dtoc(vdatarec),4,2))+1),2,0)+"/"+substr(dtoc(vdatarec),7,4))-1
      Set SoftSeek Off
      While vdataini<=rec->datarec .and.  vdatafim>=rec->datarec .and. !Eof()
         If  rec->tiporec="E"
            vReceitas+=rec->valorec
         else
            vDespesas+=rec->valorec
         endif
         AADD(aItensRec[1],rec->datarec)
         AADD(aItensRec[2]," "+rec->tiporec+" ")
         AADD(aItensRec[3],rec->descrec)
         AADD(aItensRec[4],rec->parcrec)
         AADD(aItensRec[5],rec->parcnum)
         AADD(aItensRec[6],rec->valorec)
         Select Rec
         Skip
      End
      vRendimen:=vReceitas-vDespesas
      vrodape:="Receitas    -   Despesas     = Rendimentos : "+transform( vReceitas , "@E 999,999,999.99")+" - "+transform( vDespesas , "@E 999,999,999.99")+" = "+transform( vRendimen, "@E 999,999,999.99")
      //"1234567890123456789012345678901234567890"

   case tipo=2
      Select rec
      Set order to 1
      Go top

      vtituloo:="Relação de Todas as Entradas"
      While !Eof()
         if rec->tiporec="E"
            vRendimen+=rec->valorec
            AADD(aItensRec[1],rec->datarec)
            AADD(aItensRec[2]," "+rec->tiporec+" ")
            AADD(aItensRec[3],rec->descrec)
            AADD(aItensRec[4],rec->parcrec)
            AADD(aItensRec[5],rec->parcnum)
            AADD(aItensRec[6],rec->valorec)
         endif
         Select Rec
         Skip
      End
      vRodape:="Total: "+ Transform(vRendimen,"@E 999,999,999.99")
   case tipo=3
      Select rec
      Set order to 1
      Go top

      vtituloo:="Relação de Todas as Saidas"
      While !Eof()
         if rec->tiporec!="E"
            vRendimen+=rec->valorec
            AADD(aItensRec[1],rec->datarec)
            AADD(aItensRec[2]," "+rec->tiporec+" ")
            AADD(aItensRec[3],rec->descrec)
            AADD(aItensRec[4],rec->parcrec)
            AADD(aItensRec[5],rec->parcnum)
            AADD(aItensRec[6],rec->valorec)
         endif
         Select Rec
         Skip
      End
      vRodape:="Total: "+ Transform(vRendimen,"@E 999,999,999.99")
   endcase
   FrPrn:=frReportManager():new()
   FrPrn:NewReport("Page1")
   PropriedadesFR("Page1","Height=1000;Left=0;Top=0;Width=1000;Name=Page1;Font.Charset=1;Font.Color=0;Font.Height=-9;Font.Name=tableau;Font.Style=0;PaperWidth=210;PaperHeight=297;PaperSize=9;LeftMargin=10;RightMargin=10;TopMargin=10;BottomMargin=10;ColumnWidth=0;ColumnPositions.Text=;HGuides.Text=;VGuides.Text=")

   //FrPrn:LoadFromFile("c:\des\cedro\entr1geral.fr3")
   FrPrn:SetUserDataSet( "REC","DATAREC;TIPOREC;DESCREC;PARCREC;PARCNUM;VALOREC",{||I := 1},{||I := I + 1},{||I := I - 1},{||I > Len(aItensRec[1])},{|cField| X:= Campo1VetorRec(cField,I) ,X  })
   //FrPrn:SetProperty("MasterData2","DataSetName","REC")

   ** Apos o LoadFromFile
   frprn:addvariable("Variaveis", "vnomeemp","'&vNOMEEMP'")
   frprn:addvariable("Variaveis", "vendeemp","'&vENDEEMP'")
   frprn:addvariable("Variaveis", "vnumeemp","'&vNUMEEMP'")
   frprn:addvariable("Variaveis", "vbairemp","'&vBAIREMP'")
   frprn:addvariable("Variaveis", "vcidaemp","'&vCIDAEMP'")
   frprn:addvariable("Variaveis", "vufempre","'&vUFEMPRE'")
   frprn:addvariable("Variaveis", "vcepempr","'&vCEPEMPR'")
   frprn:addvariable("Variaveis", "vcnpjemp","'&vCNPJEMP'")
   frprn:addvariable("Variaveis", "vteleemp","'&vTELEEMP'")
   frprn:addvariable("Variaveis", "vativemp","'&vATIVEMP'")
   frprn:addvariable("Variaveis", "vemaiemp","'&vEMAIEMP'")
   frprn:addvariable("Variaveis", "vsiteemp","'&vSITEEMP'")
   frprn:addvariable("Variaveis", "vlogoemp","'&vLOGOEMP'")
   frprn:addvariable("Variaveis", "vtituloo","'&vtituloo'")
   frprn:addvariable("Variaveis", "vreceitas","'&vReceitas'")
   frprn:addvariable("Variaveis", "vdespesas","'&vDespesas'")
   frprn:addvariable("Variaveis", "vrendimen","'&vRendimen'")
   frprn:addvariable("Variaveis", "vrodape","'&vrodape'")

   asp:=[']

   FrPrn:AddBand("PageFooter1","Page1",frxPageFooter)
   PropriedadesFR("PageFooter1","Height=41,57483N*;Left=0N*;Top=464,88219N*;Width=718,1107N*")

   FrPrn:AddMemo("PageFooter1","vsiteemp",'[vsiteemp]'+CRLF+'[vemaiemp]',3.77953,0,710.55164,37.7953)
   PropriedadesFR("vsiteemp","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=0;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;Frame.Style=fsDouble;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False;VAlign=vaCenter")

   FrPrn:AddMemo("PageFooter1","Date",'[Date]',608.50433,15.11812,102.04731,18.89765)
   PropriedadesFR("Date","ShowHint=False;Font.Charset=1;Font.Color=0;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;Frame.Color=8421504;HAlign=haCenter;ParentFont=False;VAlign=vaCenter")

   FrPrn:AddMemo("PageFooter1","Page",'Pag:[Page#]/[TotalPages#]',608.50433,0,105.82684,18.89765)
   PropriedadesFR("Page","ShowHint=False;Font.Charset=1;Font.Color=0;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;Frame.Color=8421504;HAlign=haCenter;ParentFont=False;VAlign=vaCenter")

   FrPrn:AddBand("PageHeader1","Page1",frxPageHeader)
   PropriedadesFR("PageHeader1","Height=151,1812N*;Left=0N*;Top=86,92919N*;Width=718,1107N*")

   FrPrn:AddMemo("PageHeader1","Memo6",'',0,0,718.1107,124.72449)
   PropriedadesFR("Memo6","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-17;Font.Name=Arial;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False")

   FrPrn:AddPicture("PageHeader1","Picture1",vlogoemp,3.77953,3.77953,151.1812,117.16543)
   PropriedadesFR("Picture1","ShowHint=False;Center=True;Frame.Typ=15;HightQuality=False")

   FrPrn:AddMemo("PageHeader1","vnomeemp",'[vnomeemp]',158.74026,0,559.37044,22.67718)
   PropriedadesFR("vnomeemp","ShowHint=False;Font.Charset=1;Font.Color=-16777208;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;ParentFont=False")

   FrPrn:AddMemo("PageHeader1","vendeemp",'End:[vendeemp]',158.74026,22.67718,464.88219,18.89765)
   PropriedadesFR("vendeemp","ShowHint=False;Font.Charset=1;Font.Color=-16777208;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;ParentFont=False")

   FrPrn:AddMemo("PageHeader1","vnumeemp",'Nrº:[vnumeemp]',627.40198,22.67718,90.70872,18.89765)
   PropriedadesFR("vnumeemp","ShowHint=False;Font.Charset=1;Font.Color=-16777208;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;ParentFont=False")

   FrPrn:AddMemo("PageHeader1","vbairemp",'Bairro:[vbairemp]',158.74026,45.35436,173.85838,22.67718)
   PropriedadesFR("vbairemp","ShowHint=False;Font.Charset=1;Font.Color=-16777208;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;ParentFont=False")

   FrPrn:AddMemo("PageHeader1","vcidaemp",'Cidade:[vcidaemp]',336.37817,45.35436,196.53556,22.67718)
   PropriedadesFR("vcidaemp","ShowHint=False;Font.Charset=1;Font.Color=-16777208;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;ParentFont=False")

   FrPrn:AddMemo("PageHeader1","vufempre",'Uf:[vufempre]',532.91373,45.35436,60.47248,22.67718)
   PropriedadesFR("vufempre","ShowHint=False;Font.Charset=1;Font.Color=-16777208;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;ParentFont=False")

   FrPrn:AddMemo("PageHeader1","vcepempr",'Cep:[vcepempr]',597.16574,45.35436,120.94496,22.67718)
   PropriedadesFR("vcepempr","ShowHint=False;Font.Charset=1;Font.Color=-16777208;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;ParentFont=False")

   FrPrn:AddMemo("PageHeader1","vcnpjemp",'CnpjCpf:[vcnpjemp]',423.30736,68.03154,219.21274,22.67718)
   PropriedadesFR("vcnpjemp","ShowHint=False;Font.Charset=1;Font.Color=-16777208;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;ParentFont=False")

   FrPrn:AddMemo("PageHeader1","vteleemp",'Telefone:[vteleemp]',158.74026,68.03154,260.78757,22.67718)
   PropriedadesFR("vteleemp","ShowHint=False;Font.Charset=1;Font.Color=-16777208;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;ParentFont=False")

   FrPrn:AddMemo("PageHeader1","vativemp",'[vativemp]',158.74026,90.70872,559.37044,22.67718)
   PropriedadesFR("vativemp","ShowHint=False;Font.Charset=1;Font.Color=-16777208;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;ParentFont=False")

   FrPrn:AddMemo("PageHeader1","Memo1",'Data',0,128.50402,139.84261,22.67718)
   PropriedadesFR("Memo1","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-16;Font.Name=Arial Narrow;Font.Style=[fsBold];Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False")

   FrPrn:AddMemo("PageHeader1","Memo2",'Descrição',139.84261,128.50402,362.83488,22.67718)
   PropriedadesFR("Memo2","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-16;Font.Name=Arial Narrow;Font.Style=[fsBold];Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False")

   FrPrn:AddMemo("PageHeader1","Memo4",'Parcela',502.67749,128.50402,94.48825,22.67718)
   PropriedadesFR("Memo4","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-16;Font.Name=Arial Narrow;Font.Style=[fsBold];Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False")

   FrPrn:AddMemo("PageHeader1","Memo5",'Valor',597.16574,128.50402,120.94496,22.67718)
   PropriedadesFR("Memo5","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-16;Font.Name=Arial Narrow;Font.Style=[fsBold];Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False")
   FrPrn:AddBand("MasterData2","Page1",frxMasterData)
   PropriedadesFR("MasterData2","Height=22,67718N*;Left=0N*;Top=298,58287N*;Width=718,1107N*;ColumnWidth=0;ColumnGap=0;DataSetName=REC;KeepFooter=True;RowCount=0")
   FrPrn:AddMemo("MasterData2","RECDATAREC",'[REC."DATAREC"]',0,0,139.84261,22.67718)
   PropriedadesFR("RECDATAREC",'ShowHint=False;Color=-16777192;DataSetName=REC;Font.Charset=1;Font.Color=255;Font.Height=-12;Font.Name=Comic Sans MS;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];Highlight.Font.Charset=1;Highlight.Font.Color=32768;Highlight.Font.Height=-12;Highlight.Font.Name=Comic Sans MS;Highlight.Font.Style=0;Highlight.Color=-16777192;Highlight.Condition=<REC."TIPOREC">=&asp E &asp;ParentFont=False')
   FrPrn:AddMemo("MasterData2","RECPARCNUM",'[REC."PARCNUM"]/[REC."PARCREC"]',502.67749,0,94.48825,22.67718)
   PropriedadesFR("RECPARCNUM",'ShowHint=False;Color=-16777192;DataSetName=REC;Font.Charset=1;Font.Color=255;Font.Height=-12;Font.Name=Comic Sans MS;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];HAlign=haCenter;Highlight.Font.Charset=1;Highlight.Font.Color=32768;Highlight.Font.Height=-12;Highlight.Font.Name=Comic Sans MS;Highlight.Font.Style=0;Highlight.Color=-16777192;Highlight.Condition=<REC."TIPOREC">=&asp E &asp;ParentFont=False;VAlign=vaCenter')
   FrPrn:AddMemo("MasterData2","RECTIPOREC",'[REC."TIPOREC"]',139.84261,0,0,22.67718)
   PropriedadesFR("RECTIPOREC",'ShowHint=False;DataSetName=REC;Font.Charset=1;Font.Color=-16777208;Font.Height=-16;Font.Name=Britannic Bold;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False')
   FrPrn:AddMemo("MasterData2","Memo7",'[REC."DESCREC"]',139.84261,0,362.83488,22.67718)
   PropriedadesFR("Memo7",'ShowHint=False;Color=-16777192;DataSetName=REC;Font.Charset=1;Font.Color=255;Font.Height=-12;Font.Name=Comic Sans MS;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];Highlight.Font.Charset=1;Highlight.Font.Color=32768;Highlight.Font.Height=-12;Highlight.Font.Name=Comic Sans MS;Highlight.Font.Style=0;Highlight.Color=-16777192;Highlight.Condition=<REC."TIPOREC">=&asp E &asp;ParentFont=False')
   FrPrn:AddMemo("MasterData2","Memo8",'[REC."VALOREC"]',597.16574,0,120.94496,22.67718)
   PropriedadesFR("Memo8",'ShowHint=False;Color=-16777192;DataSetName=REC;DisplayFormat.FormatStr=%2.2n;DisplayFormat.Kind=fkNumeric;Font.Charset=1;Font.Color=255;Font.Height=-12;Font.Name=Comic Sans MS;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];HAlign=haCenter;Highlight.Font.Charset=1;Highlight.Font.Color=32768;Highlight.Font.Height=-12;Highlight.Font.Name=Comic Sans MS;Highlight.Font.Style=0;Highlight.Color=-16777192;Highlight.Condition=<REC."TIPOREC">=&asp E &asp;ParentFont=False;VAlign=vaCenter')
   FrPrn:AddBand("ReportTitle1","Page1",frxReportTitle)
   PropriedadesFR("ReportTitle1","Height=45,35436N*;Left=0N*;Top=18,89765N*;Width=718,1107N*")

   FrPrn:AddMemo("ReportTitle1","vtituloo",'[vtituloo]',2,0,714.33117,41.57483)
   PropriedadesFR("vtituloo","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-27;Font.Name=Comic Sans MS;Font.Style=[fsBold];Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];HAlign=haCenter;ParentFont=False")
   FrPrn:AddBand("Footer1","Page1",frxFooter)
   PropriedadesFR("Footer1","Height=60,47248N*;Left=0N*;Top=343,93723N*;Width=718,1107N*;Stretched=True")

   FrPrn:AddMemo("Footer1","Memo9",'[vrodape]',11.33859,7.55906,702.99258,34.01577)
   PropriedadesFR("Memo9","ShowHint=False;Color=15793151;Font.Charset=1;Font.Color=16711680;Font.Height=-15;Font.Name=Arial Narrow;Font.Style=[fsBold];Frame.Style=fsDashDotDot;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];HAlign=haRight;ParentFont=False")


   FrPrn:SetFileName(vtituloo) //so no finalzinho

   PadraoFastReport()
   Select rec
   go top
   Return


Function Campo1VetorRec(cField,I)
   Do Case
   case cField="DATAREC"
      Return aItensRec[1,I]
   case cField="TIPOREC"
      return aItensRec[2,I]
   case cField="DESCREC"
      return aItensRec[3,I]
   case cField="PARCREC"
      return aItensRec[4,I]
   case cField="PARCNUM"
      return aItensRec[5,I]
   case cField="VALOREC"
      return aItensRec[6,I]
   ENDCASE
   ////////////////////////////////////////////////////////////////////////////////
Function PadraoFastReport()
   FrPrn:SetIcon("CEDRO")
   FrPrn:PreviewOptions:SetButtons(FR_PB_PRINT+FR_PB_EXPORT+FR_PB_ZOOM+FR_PB_FIND+FR_PB_OUTLINE+FR_PB_PAGESETUP+FR_PB_TOOLS+FR_PB_NAVIGATOR+FR_PB_PDFANDMAIL)
   if File(CurDrive()+":\desenv.sys")
      FrPrn:DesignReport()
   else
      FrPrn:ShowReport()
   endif
   FrPrn:DestroyFR()
   Return



Function Est1Exc(oLbxdr)
   vcodirec:=rec->codirec
   vnumerec:=rec->parcnum
   vparcelap:=1
   vparcelat:=rec->PARCREC
   if MsgYesNo("Deseja Apagar o Lançamento?","Pergunta")
      Select Rec
      Set Order to 8
      Go Top
      Seek vcodirec
      While !Eof() .and. vcodirec=rec->codirec
         Select Rec
         if (rec->parcnum<>vnumerec)
            if RLOCK()
               replace rec->parcnum with strzero(vparcelap,2,0)
               replace rec->PARCREC with strzero(val(vparcelat)-1,2,0)
               dbunlock()
               vparcelap++
            endif
         else
            if RLOCK()
               DbDelete()
               DbUnlock()
            else
               MSGINFO("Não é Possivel Excluir o Arquivo , atençao feche o programa e abra novamente")
            endif
         endif
         Skip
      end
   endif
   Select Rec
   Set Order to 2
   Go Top
Function FuncImp()
   Local oradio1,oDlgimp,lsave:=.f.,oprn2
   public TipoRel:="M"
   nordimp=1
   Sysrefresh()
   retornoimp=.t.
   IF getprintdc()==0
      retornoimp=.f.
      return retornoimp
   endif
   printer oprn
   tipimp:=oprn:nLogPixelx()
   if tipimp<300
      TipoRel:="M"
   elseif tipimp>=299
      TipoRel:="J"
   endif
   *? tipimp
   * if msgyesno("Confirma impressora escolhida para iniciar impressão !!!","Pergunta")
      retornoimp=.t.
   * else
      *   retornoimp=.f.
   * endif
   return retornoimp
Function Resolucao_Impressora()
   Public nTam,resolucao_Impressora
   resolucao_Impressora=oprn:nlogpixelx()
   nTam   :=18
   if resolucao_Impressora>=100  // Matricial
      nTam:=08
   endif
   if resolucao_Impressora>=300  // Jato de Tinta
      ntam:=18
   endif
   if resolucao_Impressora>=600  // Termica
      ntam:=35
   endif
   if resolucao_Impressora>=900  // TERMICA SUPER FAST
      ntam:=52
   endif
   Return .t.

Function Est1ResumoMensal(vdatarec)


   if funcimp()=.f.
      CLOSE DATA
      retu .t.
   endif
   CursorWait()
   cTitulo:="Resumo Mensal Mes:"+SubStr(dtoc(vdatarec),4,2)+ " - "+CMonth(vDatarec)
   PRINT oPrn NAME cTitulo PREVIEW

   nTam   :=18
   nTamRel:=92
   resolucao_impressora()

   nTamPag:=66
   tlin   :=62

   DEFINE FONT oFontic NAME "Britannic Bold" size ntam+3,-12 OF oPrn
   DEFINE FONT oFonti1 NAME "Times New Roman" size ntam+1,-12 of oPrn
   DEFINE FONT oFonti2 NAME "Arial" size ntam,-12 OF oPrn
   DEFINE FONT oFonti3 NAME "Courier New" size ntam,-12 OF oPrn

   *
   *
   if empty( oprn:hdc )
      MsgStop( "Impressora não está pronta !!!" )
      return nil
   endif
   /*
   01/12/1994
   1234567890
   3
   */
   vdataini= ctod("01"+substr(dtoc(vdatarec),3,8))
   vdatafim= ctod("01/"+strzero((val(substr(dtoc(vdatarec),4,2))+1),2,0)+"/"+substr(dtoc(vdatarec),7,4))-1
   vdespesas:=0.00
   vreceitas:=0.00
   inicio=0
   npag:=0
   Set SoftSeek On
   Select Rec
   Set Order to 2
   Go Top
   Seek dtos(vdataini)
   While !Eof() .and. vdataini<=rec->datarec .and.  vdatafim>=rec->datarec
      Cab_Rel1()
      if rec->tiporec="E"
         SetTextColor( oPrn:hDCOut, CLR_GREEN )
      else
         SetTextColor( oPrn:hDCOut, CLR_HRED )
      endif
      oPrn:charsay(tlin,02,dtoc(rec->datarec))
      oPrn:charsay(tlin,13,rec->descrec)
      oPrn:charsay(tlin,51,rec->parcnum+"/"+rec->parcrec)
      if rec->tiporec="E"
         oprn:charsay(tlin,81, transform(rec->valorec,"@e + 99,999.99" ))
         vreceitas+=rec->valorec
      else
         oprn:charsay(tlin,81, transform(rec->valorec,"@e - 99,999.99" ))
         vdespesas+=rec->valorec

      endif
      tlin++
      inicio++
      Select rec
      Skip
   end
   vrendimento:=vreceitas-vdespesas
   SetTextColor( oPrn:hDCOut, CLR_BLACK )
   oPrn:Charsay(tlin,01,replicate("-",120))
   tlin++
   oPrn:charsay(tlin,02,"Receitas    -    Despesas      =  Rendimento ")
   tlin++
   oPrn:charsay(tlin,02,transform(vreceitas,"@e 99,999.99"))
   oPrn:charsay(tlin,14,"-")
   oPrn:charsay(tlin,18,transform(vdespesas,"@e 99,999.99"))
   oPrn:charsay(tlin,33,"=")
   if vrendimento>=0
      SetTextColor( oPrn:hDCOut, CLR_GREEN )
   else
      SetTextColor( oPrn:hDCOut, CLR_HRED )
   endif
   oPrn:charsay(tlin,35,transform(vrendimento,"@e 99,999.99"))
   SetTextColor( oPrn:hDCOut, CLR_BLACK )

   if inicio=0
      msginfo("Não Existem informações para imprimir...","Atenção")
      retu
   endif
   oprn:lprvmodal:=.T.
   endpage
   endprint
   oFontic:end()
   oFonti1:end()
   oFonti2:end()
   oFonti3:end()
   Set SoftSeek Off
   Select Rec
   Set Order to 2
   Go Top
   SysRefresh()
   Cursor()

Function Est1ResumoLancamentos()
   Local pAno:=space(4)
   If ! MsgGet("Informe o Ano","Ano do Resumo:",@pAno)
      return .f.
   endif


   if funcimp()=.f.
      CLOSE DATA
      retu .t.
   endif
   CursorWait()
   cTitulo:="Resumos de Rendimentos Anuais"
   PRINT oPrn NAME cTitulo PREVIEW

   nTam   :=18
   nTamRel:=92
   resolucao_impressora()

   nTamPag:=66
   tlin   :=62

   DEFINE FONT oFontic NAME "Britannic Bold" size ntam+3,-12 OF oPrn
   DEFINE FONT oFonti1 NAME "Times New Roman" size ntam+1,-12 of oPrn
   DEFINE FONT oFonti2 NAME "Arial" size ntam,-12 OF oPrn
   DEFINE FONT oFonti3 NAME "Courier New" size ntam,-12 OF oPrn

   *
   *
   if empty( oprn:hdc )
      MsgStop( "Impressora não está pronta !!!" )
      return nil
   endif
   /*
   01/12/1994
   1234567890
   3
   */
   vRendimentos:=0.00
   vdespesas:=0.00
   vreceitas:=0.00
   inicio=0
   npag:=0

   TotDespesas:=0.00
   TotReceitas:=0.00
   TotRendimen:=0.00
   Set SoftSeek On
   Select Rec
   Set Order to 6
   seek ctod("01/01/"+pano)
   Set SoftSeek Off

   vmes=substr(dtoc(rec->datarec),4,2)
   vano=substr(dtoc(rec->datarec),7,4)

   //? vmes,vano
   While !Eof()
      Cab_Rel2()

      if substr(dtoc(rec->datarec),4,2)<>vmes .and. vano=pAno
         vrendimentos:=vreceitas-vdespesas
         TotDespesas+= vdespesas
         TotReceitas+= vreceitas
         TotRendimen+= vrendimentos
         oPrn:charsay(tlin,01,vmes+" - "+smes(vmes))
         oPrn:charsay(tlin,14,"\"+vano)
         SetTextColor( oPrn:hDCOut, CLR_GREEN )
         oprn:charsay(tlin,25, transform(vreceitas,"@e + 99,999.99" ))
         SetTextColor( oPrn:hDCOut, CLR_HRED )
         oprn:charsay(tlin,40, transform(vdespesas,"@e - 99,999.99" ))
         if vrendimentos>0
            SetTextColor( oPrn:hDCOut, CLR_HBLUE )
         else
            SetTextColor( oPrn:hDCOut, CLR_RED )
         endif
         oprn:charsay(tlin,55, transform(vrendimentos,"@e = 99,999.99" ))
         SetTextColor( oPrn:hDCOut, CLR_BLACK )
         vdespesas:=0.00
         vreceitas:=0.00
         vmes=substr(dtoc(rec->datarec),4,2)
         vano=substr(dtoc(rec->datarec),7,4)
         tlin++
         inicio++
      endif
      if rec->tiporec="E"
         vreceitas+=rec->valorec
      else
         vdespesas+=rec->valorec
      endif

      Select rec
      Skip
   end
   oPrn:Charsay(tlin,01,replicate("-",120))
   tlin++
   oPrn:charsay(tlin,02,"Total :  Receitas    -    Despesas      =  Rendimento ")
   tlin++
   oPrn:charsay(tlin,10,transform(TotReceitas,"@e 99,999.99"))
   oPrn:charsay(tlin,23,"-")
   oPrn:charsay(tlin,28,transform(TotDespesas,"@e 99,999.99"))
   oPrn:charsay(tlin,42,"=")
   if TotRendimen>=0
      SetTextColor( oPrn:hDCOut, CLR_GREEN )
   else
      SetTextColor( oPrn:hDCOut, CLR_HRED )
   endif
   oPrn:charsay(tlin,45,transform(TotRendimen,"@e 99,999.99"))
   SetTextColor( oPrn:hDCOut, CLR_BLACK )

   if inicio=0
      msginfo("Não Existem informações para imprimir...","Atenção")
      retu
   endif
   oprn:lprvmodal:=.T.
   endpage
   endprint
   oFontic:end()
   oFonti1:end()
   oFonti2:end()
   oFonti3:end()
   Select Rec
   Set Order to 2
   Go Top
   SysRefresh()
   Cursor()

Function Cab_Rel1()

   If tlin > 60
      npag ++
      if inicio>0
         endpage
      endif
      page
      Cabe_Jat(npag)
      tlin:=05
      oPrn:Charsay(tlin,01,replicate("-",120))
      tlin++
      oPrn:SetFont(oFonti3)
      oPrn:Charsay(tlin,01,"Data")
      oPrn:Charsay(tlin,12,"Descrição")
      oPrn:Charsay(tlin,50,"Parc.")
      oPrn:Charsay(tlin,80,"Valor")
      tlin++
   endif
Function Cab_Rel2()

   If tlin > 60
      npag ++
      if inicio>0
         endpage
      endif
      page
      Cabe_Jat(npag)
      tlin:=05
      oPrn:Charsay(tlin,01,replicate("-",120))
      tlin++
      oPrn:SetFont(oFonti3)
      oPrn:Charsay(tlin,01,"Mes/Ano")
      oPrn:Charsay(tlin,25,"Receitas")
      oPrn:Charsay(tlin,40,"Despesas")
      oPrn:Charsay(tlin,55,"Rendimentos")
      tlin++
   endif
Function Cabe_Jat(npag)
   oPrn:SetFont(oFontic)
   oPrn:CharSay(01,002,emp->nomeemp)
   oPrn:CharSay(02,002,emp->ativemp)
   oPrn:SetFont(oFonti1)
   oPrn:CharSay(01,055,"Página:"+Str(nPag,4),"D")
   oPrn:CharSay(02,055,"Data:"+Dtoc(Date()),"D")
   oPrn:CharSay(03,002,"Cedro - Controle de Receitas e Despesas ®")
   oPrn:CharSay(04,002,cTitulo)
   retu .t.
Function sMes(cMes)
   if cMes="01"
      return "Janeiro"
   endif
   if cMes="02"
      return "Fevereiro"
   endif
   if cMes="03"
      return "Março"
   endif
   if cMes="04"
      return "Abril"
   endif
   if cMes="05"
      return "Maio"
   endif
   if cMes="06"
      return "Junho"
   endif
   if cMes="07"
      return "Julho"
   endif
   if cMes="08"
      return "Agosto"
   endif
   if cMes="09"
      return "Setembro"
   endif
   if cMes="10"
      return "Outubro"
   endif
   if cMes="11"
      return "Novembro"
   endif
   if cMes="12"
      return "Dezembro"
   endif



Function Est1Inc(oLbxdr,lAppend,vtiporec)
   && Limpa Variaveis
   Select rec
   Set Order to 9
   if lAppend
      Go Bottom
      VCODIREC:=strzero(val(rec->codirec)+1,len(rec->codirec),0)
      Skip
      vdatarec:=date()
      vdescrec:=space(len(rec->descrec))
      vparcrec:="01"
      vvalorec:=rec->valorec

   Else
      vtiporec:=rec->tiporec
      vdatarec:=rec->datarec
      vdescrec:=rec->descrec
      vparcrec:=rec->parcrec
      vvalorec:=rec->valorec
      VCODIREC:=rec->codirec
   endif
   lsave:=.f.
   Define Dialog oDlgEst121 Resource "EST1_MAIN1INCLU" TITLE "Cedro - Incluir "+if(vtiporec="E","Receita","Despesa")

   Redefine get odatarec var vdatarec id 4002 of  oDlgEst121 valid !Empty(vdatarec)
   if vtiporec="E"
      odatarec:ctooltip:= "Dt.Entrada:"+CRLF+;
       "Data Referente a quando o valor informado vai entrar no mês,"+CRLF+;
       "Ex:Salário , Entra no começo do mes, entao todo dia 01 Será Creditado. "+CRLF+;
       "Atençao , a Entrada vai se Repetir Todos os Meses De Acordo com a data e a qtd. Infomada Abaixo."
   else
      odatarec:ctooltip:= "Dt.Saida:"+CRLF+;
       "Data referente a o desconto ou seja , quando deve ser descontado da entrada essa saida"+CRLF+;
       "tambem é usada para identificar qual o mes de pagamento ."
   endif
   Redefine get odescrec var vdescrec id 4004 of  oDlgEst121 valid (!Empty(vdescrec))
   Redefine get oparcrec var vparcrec id 4006 of  oDlgEst121 valid (val(vparcrec)>0) when lAppend
   Redefine get ovalorec var vvalorec Pict "@e 99,999.99" id 4008 of  oDlgEst121 valid ((vvalorec)>0)

   REDEFINE BUTTONBMP ID 4010 OF oDlgEst121 ACTION (lSave:=.t.,oDlgEst121:End())
   REDEFINE BUTTONBMP ID 4011 OF oDlgEst121 ACTION (lSave:=.f.,oDlgEst121:End()) cancel

   Activate Dialog oDlgEst121 Centered
   if lSave
      if lAppend
         for x:=0 to val(vparcrec)-1
            Select Rec
            Append Blank
            if RLOCK()
               Replace datarec with datames(vdatarec,x)
               replace TIPOREC WITH vtiporec
               REPLACE DESCREC WITH vdescrec
               REPLACE VALOREC WITH VVALOREC
               REPLACE PARCREC WITH VPARCREC
               REPLACE PARCNUM WITH STRZERO(X+1,2,0)+STRZERO(val(vparcrec),2,0)
               replace CODIREC with VCODIREC
               DbUnlock()
            ENDIF
            DbCommitAll()
         NEXT
      else
         Select Rec
         if RLOCK()
            Replace datarec with vdatarec
            replace TIPOREC WITH vtiporec
            REPLACE DESCREC WITH vdescrec
            REPLACE VALOREC WITH VVALOREC
            REPLACE PARCREC WITH VPARCREC
            //REPLACE PARCNUM WITH STRZERO(X,2,0)+STRZERO(val(vparcrec),2,0)
            DbUnlock()
         ENDIF
         DbCommitAll()
      endif
   endif
   Select REC
   Set Order to 2
   GO TOP

Function DadosEMpresa()


   Select Emp
   vNOMEEMP:=emp->NOMEEMP
   vENDEEMP:=emp->ENDEEMP
   vNUMEEMP:=emp->NUMEEMP
   vBAIREMP:=emp->BAIREMP
   vCIDAEMP:=emp->CIDAEMP
   vUFEMPRE:=emp->UFEMPRE
   vCEPEMPR:=emp->CEPEMPR
   vCNPJEMP:=emp->CNPJEMP
   vTELEEMP:=emp->TELEEMP
   vATIVEMP:=emp->ATIVEMP
   vEMAIEMP:=emp->EMAIEMP
   vSITEEMP:=emp->SITEEMP
   vLOGOEMP:=emp->LOGOEMP

   lsave:=.f.
   Define Dialog oDlgEmp Resource "EST1_EMP" Title "Cadastro de Dados Pessoais ou da Empresa"
   nId:=99
   redefine get onomeemp var vnomeemp id ++nid of odlgemp valid !Empty(vnomeemp)
   redefine get oendeemp var vendeemp id ++nid of odlgemp
   redefine get onumeemp var vnumeemp id ++nid of odlgemp pict "99999"
   redefine get obairemp var vbairemp id ++nid of odlgemp
   redefine get ocidaemp var vcidaemp id ++nid of odlgemp
   redefine get oufempre var vufempre id ++nid of odlgemp pict "!!"
   redefine get ocepempr var vcepempr id ++nid of odlgemp pict "99999-999"
   redefine get ocnpjemp var vcnpjemp id ++nid of odlgemp
   redefine get oteleemp var vteleemp id ++nid of odlgemp pict "(99)9999-9999"
   redefine get oativemp var vativemp id ++nid of odlgemp valid !Empty(vativemp)
   redefine get oemaiemp var vemaiemp id ++nid of odlgemp
   redefine get ositeemp var vsiteemp id ++nid of odlgemp
   redefine get ologoemp var vlogoemp id ++nid of odlgemp ;
    action (vlogoemp:=cGetFile32( "bmp (*.bmp) | *.bmp |All files (*.*) | *.* |","Selecione um Arquivo de Imagem" )) bitmap "PASTA"

   REDEFINE BUTTON ID ++nid OF odlgemp ACTION (lsave:=.t.,odlgemp:End())
   REDEFINE BUTTON ID ++nid OF odlgemp ACTION (lsave:=.f.,odlgemp:End()) cancel

   Activate Dialog oDLgEMp Center

   if lSave
      Select EMp
      Go Top
      if eof()
         Append Blank
      endif
      If Rlock()
         replace emp->nomeemp with StrCapFirst(vnomeemp)
         replace emp->endeemp with vendeemp
         replace emp->numeemp with vnumeemp
         replace emp->bairemp with vbairemp
         replace emp->cidaemp with vcidaemp
         replace emp->ufempre with vufempre
         replace emp->cepempr with vcepempr
         replace emp->cnpjemp with vcnpjemp
         replace emp->teleemp with vteleemp
         replace emp->ativemp with StrCapFirst(vativemp)
         replace emp->emaiemp with vemaiemp
         replace emp->siteemp with vsiteemp
         replace emp->logoemp with vlogoemp
         DbUnlock()
      endif
      DbCommit()

   endif
   if empty(vlogoemp)
      vlogoemp:=  CurDrive()+":\"+ CurDir()+"\bmp\logoemp.bmp"
   endif

Function Est1CheckUsuSen(oNomeUsu,oSenhUsu,vNomeusu,vSenhusu)

   Select Usu
   Set Order to 1
   go top
   Seek Alltrim (upper(vNomeusu))
   if ! Eof() .and. upper(alltrim(vnomeusu))=upper(alltrim(usu->nomeusu))
      if alltrim(vsenhusu)=alltrim(usu->senhusu)
         return .t.
      else
         MsgAlert("Senha Incorreta!!!","Alerta")
         oSenhUsu:nClrPane:= CLR_RED
         oSenhUsu:nClrText:= CLR_WHITE
         oSenhUsu:Refresh()
         xSetFocus(oSenhUsu)
         return .f.
      endif
   else
      MsgAlert("Usuario Não Exite ou Ocorreu Algum Erro !!","Alerta")
      oNomeUsu:nClrPane:= CLR_RED
      oNomeUsu:nClrText:= CLR_WHITE
      oNomeUsu:Refresh()
      xSetFocus(oNomeUsu)
      return .f.
   endif




Function Est1Reorgaz(lReorganiza)
   Default lReorganiza:=.t.
   Close Data
   if !File("usuario.cdx") .or. lReorganiza
      Use Usuario Exclusive
      IF ! neterr()
         Pack
         index on nomeusu tag usuario1 to usuario
         index on senhusu tag usuario2 to usuario
         index on niveusu tag usuario3 to usuario
      endif
      Close Data
   endif

   if !File("receita.cdx") .or. lReorganiza
      Use Receita Exclusive
      IF ! neterr()
         Pack
         index on TIPOREC+dtos(datarec)   tag Receita1 to Receita
         index on dtos(datarec)+TIPOREC   tag Receita2 to Receita
         index on DESCREC                 tag Receita3 to Receita
         index on VALOREC                 tag Receita4 to Receita
         index on PARCNUM+"/"+PARCREC     tag Receita5 to Receita
         index on datarec                 tag Receita6 to Receita
         index on codirec+dtos(datarec)   tag Receita7 to Receita
         index on codirec+PARCNUM         tag Receita8 to Receita
         index on codirec                 tag Receita9 to Receita
      endif
      Close Data
   endif




Function Est1DbfCria(oDlgRun)

   //Tabela de Usuario
   oDlgRun:=""
   aStr:={}
   AAdd(aStr,{"NOMEUSU","C",015,0})
   AAdd(aStr,{"SENHUSU","C",010,0})
   AAdd(aStr,{"NIVEUSU","C",001,0})
   if !File("USUARIO.DBF")
      DbCreate("USUARIO.DBF",aStr)
   else
      Est1AlterStr("USUARIO.DBF",aStr)
   endif

   //Tabela de Empresa
   aStr:={}
   AAdd(aStr,{"NOMEEMP","C",060,0}) // Nome Da Empresa
   AAdd(aStr,{"ENDEEMP","C",060,0}) // Endereço
   AAdd(aStr,{"NUMEEMP","C",005,0}) // Numero
   AAdd(aStr,{"BAIREMP","C",045,0}) // Bairro
   AAdd(aStr,{"CIDAEMP","C",045,0}) // Cidade
   AAdd(aStr,{"UFEMPRE","C",002,0}) // Uf
   AAdd(aStr,{"CEPEMPR","C",009,0}) // Cep
   AAdd(aStr,{"CNPJEMP","C",011,0}) // Cnpj
   AAdd(aStr,{"TELEEMP","C",014,0}) // Telefone
   AAdd(aStr,{"ATIVEMP","C",060,0}) // Atividade
   AAdd(aStr,{"EMAIEMP","C",065,0}) // Email
   AAdd(aStr,{"SITEEMP","C",065,0}) // Site
   AAdd(aStr,{"LOGOEMP","C",100,0}) // Logotipo
   iF !File("EMPRESA.DBF")
      DbCreate("EMPRESA.DBF",aStr)
   else
      Est1AlterStr("EMPRESA.DBF",aStr)
   endif

   // Tabela de Receitas e Despesas
   aStr:={}
   aadd(aStr,{"DATAREC","D",8 ,0})// Data Receito , referente ao Mes e ao ano , dia é o menos importante
   aadd(aStr,{"TIPOREC","C",1 ,0})// "E" OU "S" , Entrada Ou Saida
   aadd(aStr,{"DESCREC","C",100,0})// Descrição ou Nome da Despesa ou Entrada
   aadd(aStr,{"VALOREC","N",12,2})// Valor Da Entrada ou Despesa
   aadd(aStr,{"PARCREC","C",2 ,0})// Numero de Parcela , Se 0 não há parcela
   aadd(aStr,{"PARCNUM","C",2 ,0})// Numero de Parcela Lançada ex: 2/12
   aadd(aStr,{"CODIREC","C",6 ,0})// Numero de Parcela Lançada ex: 2/12
   if ! File("RECEITA.DBF")
      DbCreate("RECEITA.DBF",aStr)
   else
      Est1AlterStr("RECEITA.DBF",aStr)
   endif



Function DataMes(vdatarec,x)
   ndia:= Day(vdatarec)   //Ok
   nmes:= Month(vdatarec) //Ok
   nano:= Year(vdatarec)  //Ok
   smes = nmes+x //[numero de parcelas] soma das parcelas com o mes inicia
   xmes = smes
   ncont =0
   do while .T.
      if xmes >= 13
         xmes:=xmes - 12
         ncont=ncont+1
      endif
      if xmes<=12
         exit
      endif
      loop
   enddo
   if smes >= 13
      smes = xmes
      nano = nano+ncont
   endif

   ndia:= StrZero(ndia,2,0)
   nmes:= StrZero(smes,2,0)
   nano:= StrZero(nano,4,0)

   novadata:=ctod(ndia+"/"+nmes+"/"+nano)

   SysRefresh()
   return novadata

   /*
   Autor: Matheus Farias
   Data : 15/06/2013
   Função de Alterar Estrutura
   Baseado no Tamanho do Campo Tipo
   e Nome do Campo
   */


Function Est1AlterStr(pNomeDbf,pEstrutura)
   && Explicaçao dos Parametros Declarados
   && pNomeDbf -> Nome do Arquivo Dbf
   && pEstrutura -> Estrutura do ARQUIVO DO DBF para comparar a atual com o do arquivo dbf criado

   Dbf1:=pNomeDbf
   use "&Dbf1" Exclusive
   If Neterr()
      return .f.
   endif
   aEstrutura1:= DbStruct()
   Alias1:= Alias()
   *
   lMuda:=.f.
   && Verfica Tamanho e Detalhas da Estrutura com Nome Tamanho Tipo e Decimal
   if len(aEstrutura1)= Len(pEstrutura)
      for z:=1 to len(aEstrutura1)
         *   Nome do Campo                                 Tipo do Campo                                 Tamanho do Campo                              Tamanho dos Decimais
         if (aEstrutura1[Z][1])#(pEstrutura[Z][1]) .or. (aEstrutura1[Z][2])#(pEstrutura[Z][2]) .or. (aEstrutura1[Z][3])#(pEstrutura[Z][3]) .or. (aEstrutura1[Z][4])#(pEstrutura[Z][4])
            lMuda:=.t.
            //Break
         endif
      next
   else
      lMuda:=.t.
   endif
   if lMuda
      Close Data                      // Fecha as Tabelas
      FClose("&Dbf1")                 // Fecha a Tabela (Arquivo)
      FRename("&Dbf1","&Alias1..TEMP")// Renomeia a Tabela Antiga para *.temp
      DbCreate("&Dbf1",pEstrutura)   // Cria a Tabela com a Nova Estrutura
      Use &Dbf1 Exclusive new         // Abre a Tabela
      Append From "&Alias1..TEMP"     // Copiar da Tabela Antiga
      FClose("&Alias1..TEMP")         // Fecha o Temporario
      FClose("&Alias1..cdx")          // Fecha o Cdx
      fErase("&Alias1..TEMP")         // Apaga o Temp
      fErase("&Alias1..cdx")          // Apaga o Cdx
      DbCommitAll()
   endif



FUNCTION xSetFocus( oObj )
   *========================================================
   LOCAL _oWnd := oObj:oWnd, _oTempo := ""

   DEFINE Timer _oTempo Interval 10 of _oWnd ;
    Action ( oObj:SetFocus(), _oTempo:End() )

   ACTIVATE Timer _oTempo

   RETURN .T.
Function PropriedadesFR(oBj,Propriedades)
   Local aPro:={}
   Local aProp:={}

   aPro:=HB_ATokens(Propriedades,";")

   for x:=1 to len(aPro)
      if (AT(".",aPro[x]))>0
         aadd(aProp,Substr(aPro[x],1,AT(".",aPro[x])-1))
         aadd(aProp,Substr(aPro[x],AT(".",aPro[x])+1,AT("=",aPro[x])-(1+AT(".",aPro[x]))))
         aadd(aProp,Substr(aPro[x],AT("=",aPro[x])+1,Len(aPro[x])-AT("=",aPro[x])))
         vPriProp:=aProp[1]
         vSegProp:=aProp[2]
         DO WHILE AT('.',vSegProp) > 0
            vPriProp:=vPriProp+'.'+SubStr(vSegProp,1,At('.',vSegProp)-1)
            vSegProp:=SubStr(vSegProp,At('.',vSegProp)+1,Len(vSegProp))
         ENDDO
         aProp[1]:=vPriProp
         aProp[2]:=vSegProp
         IF right(aProp[Len(aProp)],2) == "N*"
            FrPrn:SetProperty(oBj+'.'+aProp[1],aProp[2],Val(SubStr(strtran(aProp[3],",","."),1,Len(aProp[3])-2)))
         ELSE
            FrPrn:SetProperty(oBj+'.'+aProp[1],aProp[2],aProp[3])
         ENDIF
         aProp:={}
      else
         aadd(aProp,Substr(aPro[x],1,AT("=",aPro[x])-1))
         aadd(aProp,Substr(aPro[x],AT("=",aPro[x])+1,Len(aPro[x])-AT("=",aPro[x])))
         IF right(aProp[2],2) == "N*"
            FrPrn:SetProperty(oBj,aProp[1],Val(SubStr(strtran(aProp[2],",","."),1,Len(aProp[2])-2)))
         ELSE
            FrPrn:SetProperty(oBj,aProp[1],aProp[2])
         ENDIF
         aProp:={}
      endif
   next

   Return .t.
Function FinaldoMes(pData)
   Local cData:=dtoc(pData)
   Local cDia:= "01"
   Local cMes:= strzero(Month(pData),2,0)
   Local cAno:= strzero(year(pData) ,4,0)
   nMes:= val(cmes)+1
   cMes:= strzero(nMes,2,0)
   cData:= cDia+"/"+cMes+"/"+cAno
   dData:= ctod(cData)
   if !IsDate(dData)
      cMes:="01"
      cData:= cDia+"/"+cMes+"/"+cAno
      dData:= ctod(cData)
   endif
   if dData = ctod("01/01/"+cano)
      dData =  ctod("31/12/"+cano)
   else
      dData=dData - 1
   endif
   return dData
Function IsDate(dData)

   if !Empty(dData)
      Return .t.
   else
      Return .f.
   Endif
