//============================================================================//
//   FR3  TO  PRG                                			By: Arthur Silvestre //
//                                                        						   //
//                                                                            //
//Data da Geração: 01/11/2013                                                   //
//Arquivo Importado: C:\des\Outros\cedro\entr1geral.fr3                            //
//============================================================================//
#Include "FiveWin.CH"
#Include "FastRepH.CH"


Function Main()
	FrPrn:=frReportManager():new()

	AddVariavel()

	FrPrn:ShowReport()
	FrPrn:DestroyFR()
Return .T.


Function AddVariavel()
//Nova Pagina//
FrPrn:NewReport("Page1")
   PropriedadesFR("Page1","Height=1000;Left=0;Top=0;Width=1000;Name=Page1;Font.Charset=1;Font.Color=0;Font.Height=-9;Font.Name=tableau;Font.Style=0;PaperWidth=210;PaperHeight=297;PaperSize=9;LeftMargin=10;RightMargin=10;TopMargin=10;BottomMargin=10;ColumnWidth=0;ColumnPositions.Text=;HGuides.Text=;VGuides.Text=")

FrPrn:SetProperty("Report", "ScriptLanguage", "PascalScript ")
FrPrn:SetProperty("Report.ScriptText", "Text", StrTran( "&#13;&#10;begin&#13;&#10;      Picture1.Picture.LoadFromFile(&#60;vlogoemp&#62;);&#13;&#10;     &#13;&#10;  &#13;&#10;end." ,"&#13;&#10;" , CRLF ) )

FrPrn:AddBand("PageFooter1","Page1",frxPageFooter)
   PropriedadesFR("PageFooter1","Height=41,57483N*;Left=0N*;Top=464,88219N*;Width=718,1107N*")

    FrPrn:AddMemo("PageFooter1","vsiteemp",'[vsiteemp]&#13;&#10;[vemaiemp]',3.77953,0,710.55164,37.7953)
      PropriedadesFR("vsiteemp","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=0;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;Frame.Style=fsDouble;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False;VAlign=vaCenter")

    FrPrn:AddMemo("PageFooter1","Date",'[Date]',608.50433,15.11812,102.04731,18.89765)
      PropriedadesFR("Date","ShowHint=False;Font.Charset=1;Font.Color=0;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;Frame.Color=8421504;HAlign=haCenter;ParentFont=False;VAlign=vaCenter")

    FrPrn:AddMemo("PageFooter1","Page",'Pag:[Page#][TotalPages#]',608.50433,0,105.82684,18.89765)
      PropriedadesFR("Page","ShowHint=False;Font.Charset=1;Font.Color=0;Font.Height=-13;Font.Name=Comic Sans MS;Font.Style=0;Frame.Color=8421504;HAlign=haCenter;ParentFont=False;VAlign=vaCenter")

FrPrn:AddBand("PageHeader1","Page1",frxPageHeader)
   PropriedadesFR("PageHeader1","Height=151,1812N*;Left=0N*;Top=86,92919N*;Width=718,1107N*")

    FrPrn:AddMemo("PageHeader1","Memo6",'',0,0,718.1107,124.72449)
      PropriedadesFR("Memo6","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-17;Font.Name=Arial;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False")

    FrPrn:AddPicture("PageHeader1","Picture1",DIGITE O CAMINHO DA IMAGEM,3.77953,3.77953,151.1812,117.16543)
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

    FrPrn:AddMemo("PageHeader1","Memo2",'Descriçao',139.84261,128.50402,362.83488,22.67718)
      PropriedadesFR("Memo2","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-16;Font.Name=Arial Narrow;Font.Style=[fsBold];Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False")

    FrPrn:AddMemo("PageHeader1","Memo4",'Parcela',502.67749,128.50402,94.48825,22.67718)
      PropriedadesFR("Memo4","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-16;Font.Name=Arial Narrow;Font.Style=[fsBold];Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False")

    FrPrn:AddMemo("PageHeader1","Memo5",'Valor',597.16574,128.50402,120.94496,22.67718)
      PropriedadesFR("Memo5","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-16;Font.Name=Arial Narrow;Font.Style=[fsBold];Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False")

FrPrn:AddBand("MasterData2","Page1",frxMasterData)
   PropriedadesFR("MasterData2","Height=22,67718N*;Left=0N*;Top=298,58287N*;Width=718,1107N*;ColumnWidth=0;ColumnGap=0;DataSetName=REC;KeepFooter=True;RowCount=0")

    FrPrn:AddMemo("MasterData2","RECDATAREC",'[REC."DATAREC"]',0,0,139.84261,22.67718)
      PropriedadesFR("RECDATAREC","ShowHint=False;Color=-16777192;DataSetName=REC;Font.Charset=1;Font.Color=255;Font.Height=-12;Font.Name=Comic Sans MS;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];Highlight.Font.Charset=1;Highlight.Font.Color=32768;Highlight.Font.Height=-12;Highlight.Font.Name=Comic Sans MS;Highlight.Font.Style=0;Highlight.Color=-16777192;Highlight.Condition=&#60;REC.&#34;TIPOREC&#34;&#62;='E';ParentFont=False")

    FrPrn:AddMemo("MasterData2","RECPARCNUM",'[REC."PARCNUM"][REC."PARCREC"]',502.67749,0,94.48825,22.67718)
      PropriedadesFR("RECPARCNUM","ShowHint=False;Color=-16777192;DataSetName=REC;Font.Charset=1;Font.Color=255;Font.Height=-12;Font.Name=Comic Sans MS;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];HAlign=haCenter;Highlight.Font.Charset=1;Highlight.Font.Color=32768;Highlight.Font.Height=-12;Highlight.Font.Name=Comic Sans MS;Highlight.Font.Style=0;Highlight.Color=-16777192;Highlight.Condition=&#60;REC.&#34;TIPOREC&#34;&#62;='E';ParentFont=False;VAlign=vaCenter")

    FrPrn:AddMemo("MasterData2","RECTIPOREC",'[REC."TIPOREC"]',139.84261,0,0,22.67718)
      PropriedadesFR("RECTIPOREC","ShowHint=False;DataSetName=REC;Font.Charset=1;Font.Color=-16777208;Font.Height=-16;Font.Name=Britannic Bold;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];ParentFont=False")

    FrPrn:AddMemo("MasterData2","Memo7",'[REC."DESCREC"]',139.84261,0,362.83488,22.67718)
      PropriedadesFR("Memo7","ShowHint=False;Color=-16777192;DataSetName=REC;Font.Charset=1;Font.Color=255;Font.Height=-12;Font.Name=Comic Sans MS;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];Highlight.Font.Charset=1;Highlight.Font.Color=32768;Highlight.Font.Height=-12;Highlight.Font.Name=Comic Sans MS;Highlight.Font.Style=0;Highlight.Color=-16777192;Highlight.Condition=&#60;REC.&#34;TIPOREC&#34;&#62;='E';ParentFont=False")

    FrPrn:AddMemo("MasterData2","Memo8",'[REC."VALOREC"]',597.16574,0,120.94496,22.67718)
      PropriedadesFR("Memo8","ShowHint=False;Color=-16777192;DataSetName=REC;DisplayFormat.FormatStr=%2.2n;DisplayFormat.Kind=fkNumeric;Font.Charset=1;Font.Color=255;Font.Height=-12;Font.Name=Comic Sans MS;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];HAlign=haCenter;Highlight.Font.Charset=1;Highlight.Font.Color=32768;Highlight.Font.Height=-12;Highlight.Font.Name=Comic Sans MS;Highlight.Font.Style=0;Highlight.Color=-16777192;Highlight.Condition=&#60;REC.&#34;TIPOREC&#34;&#62;='E';ParentFont=False;VAlign=vaCenter")

FrPrn:AddBand("ReportTitle1","Page1",frxReportTitle)
   PropriedadesFR("ReportTitle1","Height=45,35436N*;Left=0N*;Top=18,89765N*;Width=718,1107N*")

    FrPrn:AddMemo("ReportTitle1","vtituloo",'[vtituloo]',2,0,714.33117,41.57483)
      PropriedadesFR("vtituloo","ShowHint=False;Color=-16777192;Font.Charset=1;Font.Color=-16777208;Font.Height=-27;Font.Name=Comic Sans MS;Font.Style=[fsBold];Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];HAlign=haCenter;ParentFont=False")

FrPrn:AddBand("Footer1","Page1",frxFooter)
   PropriedadesFR("Footer1","Height=60,47248N*;Left=0N*;Top=343,93723N*;Width=718,1107N*;Stretched=True")

    FrPrn:AddMemo("Footer1","Memo9",'[vrodape]',11.33859,7.55906,702.99258,34.01577)
      PropriedadesFR("Memo9","ShowHint=False;Color=15793151;Font.Charset=1;Font.Color=16711680;Font.Height=-15;Font.Name=Arial Narrow;Font.Style=[fsBold];Frame.Style=fsDashDotDot;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];HAlign=haRight;ParentFont=False")

Return .t.



Function PropriedadesFR(oBj,Propriedades)
	Local aPro:={} 
	Local aProp:={} 

	aPro:=HB_ATokens(Propriedades,";")

	for x:=1 to len(aPro)
		if (AT(".",aPro[x]))>0
			 aadd(aProp,Substr(aPro[x],1,AT(".",aPro[x])-1))
		    aadd(aProp,Substr(aPro[x],AT(".",aPro[x])+1,AT("=",aPro[x])-(1+AT(".",aPro[x]))))
		    aadd(aProp,Substr(aPro[x],AT("=",aPro[x])+1,Len(aPro[x])-AT("=",aPro[x])))
		    IF right(aProp[3],2) == "N*"
			 	FrPrn:SetProperty(oBj+"."+aProp[1],aProp[2],Val(Substr(StrTran(aProp[3],",","."),1,Len(aProp[3])-2)))
		    ELSE
			 	FrPrn:SetProperty(oBj+"."+aProp[1],aProp[2],aProp[3])
		    ENDIF
			 aProp:={}
		else
		    aadd(aProp,Substr(aPro[x],1,AT("=",aPro[x])-1))
		    aadd(aProp,Substr(aPro[x],AT("=",aPro[x])+1,Len(aPro[x])-AT("=",aPro[x])))
		    IF right(aProp[2],2) == "N*"
			 	FrPrn:SetProperty(oBj,aProp[1],Val(Substr(StrTran(aProp[2],",","."),1,Len(aProp[2])-2)))
		    ELSE
			 	FrPrn:SetProperty(oBj,aProp[1],aProp[2])
		    ENDIF
			 aProp:={}
		endif
	next

Return .t.


//============================================================================//
//   FR3  TO  PRG                                			By: Arthur Silvestre //
//                                                                            //
//                                                                            //
//Data da Geração: 01/11/2013                                                   //
//Arquivo Importado: C:\des\Outros\cedro\entr1geral.fr3                            //
//============================================================================//