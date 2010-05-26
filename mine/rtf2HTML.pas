unit rtf2html;

{$WARNINGS OFF}

interface

uses
  Windows, Classes, Graphics, ComCtrls, SysUtils, Messages;

function RtfToHtml(contenthead:string; Source:TRichedit):string;

implementation

function RtfToHtml(contenthead:string; Source:TRichedit):string;
var
    SourceWidth: Integer;
    loop,loop2:integer; // Counter
    s,s2:string; // Strings, zur Bearbeitung
    fett,kursiv,us,bullet:boolean; // welche Attribute hatte das letzte Zeichen?
    Aktcolor:tColor; // aktuelle Farbe
    aktSize:integer; // aktuelle Schriftgr??e
    AktLine:Integer; // welche Zeile bearbeiten wir
    Align1:TAlignment; // wie ist die Ausrichtung
    ReihenFolge:TList; // in welche Reihenfolge werden die Tags bearbeitet
     // 1= fett
     // 2 = kursiv
     // 3 = unterstrichen
     // 4 = Color
     // 5 = Size
     // 6 = li

function CalculateSize(pt:integer):integer;
begin
  case pt of
   0..7: result:=1;
   8..10: result:=2;
   11..13: result:=3;
   14..16: result:=4;
   17..20: result:=5;
   21..24: result:=6;
   else result:=7;
  end;
end; // CalculateSize;

begin
   Result:='';
   Source.Visible:=false;
   SourceWidth := Source.Width;
   Source.Width:=32000;


   ReihenFolge:=TList.Create;

   // der Header
   s:= '';{
   '<html><head><meta name="generator" content="'+contenthead+'"></head>'+
   '<body text="#000000" bgcolor="#FFFFFF" link="#FF0000"alink="#FF0000" vlink="#FF0000">';}

   fett:=false;
   kursiv:=false;
   us:=false;
   bullet:=false;

   // wieviele Zeichen insgesamt
   Source.SelectAll;
   loop2:=Source.SelLength;

   // die Daten des ersten Zeichens herausfinden
   Source.SelLength:=1;
   //AktColor:=Source.SelAttributes.Color;
   //AktSize:=CalculateSize(Source.SelAttributes.Size);
   //Align1:=Source.Paragraph.Alignment;

   // erstmal eine v?llig willkürliche Reihenfolge festlegen
   ReihenFolge.Add(Pointer(1));
   ReihenFolge.Add(Pointer(2));
   ReihenFolge.Add(Pointer(3));
   ReihenFolge.Add(Pointer(4));
   ReihenFolge.Add(Pointer(5));
   ReihenFolge.Add(Pointer(6));

   AktLine:=0;

   // Die Fonteinstellungen des ersten Zeichens
   s:=s+'<font size="'+IntToStr(aktsize)+'" color="#'+
   IntToHex(GetRValue(AktColor),2)+
   IntToHex(GetGValue(AktColor),2)+
   IntToHex(GetBValue(AktColor),2)+'">';

   // Der erste Paragraph
   //case Align1 of
   // taLeftJustify:s:=s+'<p align="left">';
   // taRightJustify:s:=s+'<p align="right">';
   // taCenter:s:=s+'<p align="center">';
   //end;

   for loop:=0 to loop2 do
    begin
     // immer das n?chste zeichen
     Source.SelStart:=loop;
     Source.SelLength:=1;

     // jetzt wird geschaut, ob sich etwas getan hat
     with Source.SelAttributes do
      begin

     // Testen, ob wir eine neue Zeile erreicht haben, wenn ja,
     // dann entweder neuer Paragraph oder <br>
     if AktLine <> SendMessage (Source.Handle, EM_LINEFROMCHAR,
                                Source.SelStart, 0) then
      begin
       // wenn wir in einer Aufz?hlung sind, dann wird durch eine neue
       // Zeile diese immer abgeschlossen
       if bullet then
        begin
//         s:=s+'</li>';
         bullet:=false;

         ReihenFolge.Move(ReihenFolge.IndexOf(Pointer(6)),ReihenFolge.Count-1);
         // wenn in der neuen Zeile nicht wieder eine Aufz?hlung ist,
         // dann erstellen wir eine neue Zeile
         if Source.Paragraph.Numbering <> nsBullet then
          begin
          // Bevor wir in die neue Zeile wechseln, schlie?en wir alle offenen Tags
          for loop2:=0 to ReihenFolge.Count-1 do
           case Integer(Reihenfolge[loop2]) of
            1: if fett then s:=s+'</b>';
            2: if kursiv then s:=s+'</i>';
            3: if us then s:=s+'</u>';
            4: s:=s+'</font>';  
           end; // case 
          fett:=false;  
          kursiv:=false; 
          us:=false; 

           s:=s+'<br>'; 
          end; 
        end  
        else  
        begin 
         if Trim(Source.Lines[AktLine])='' then 
         // wenn die n?chste Zeile leer ist, dann fügen wir einen neuen Paragraphen 
         // ein, sonst nur ein <br> 
          begin
          // Alle offenen Tags werden geschlosssen
           for loop2:=0 to ReihenFolge.Count-1 do 
            case Integer(Reihenfolge[loop2]) of  
             1: if fett then s:=s+'</b>';  
             2: if kursiv then s:=s+'</i>'; 
             3: if us then s:=s+'</u>';  
             4: s:=s+'</font>'; 
            end; // case 
           fett:=false;
           kursiv:=false;  
           us:=false;  
           //s:=s+'</p>'; 
           Align1:=Source.Paragraph.Alignment;  
           case Align1 of 
            taLeftJustify:s:=s+'<p align="left">';  
            taRightJustify:s:=s+'<p align="right">';  
            taCenter:s:=s+'<p align="center">';
           end;  
          end else s:=s+'<br>'; 

         end; // keine Aufz?hlung 
       AktLine:=SendMessage (Source.Handle, EM_LINEFROMCHAR, 
                             Source.SelStart, 0);  
      end; // neue Zeile 

       for loop2:=0 to ReihenFolge.Count-1 do 
        case Integer(ReihenFolge[loop2]) of 

         1: if fsBold in Style then  
              begin  
               if not fett then 
                begin
                 s:=s+'<b>';
                 fett:=true;  
                 ReihenFolge.Move(loop2,0);
               end;  
              end else begin 
               if fett then 
                begin  
                 s:=s+'</b>';  
                 fett:=false;
                 ReihenFolge.Move(loop2,ReihenFolge.Count-1); 
                end;  
              end; 

            2: if fsItalic in Style then  
                begin 
                 if not kursiv then 
                  begin
                   s:=s+'<i>'; 
                   kursiv:=true;  
                   ReihenFolge.Move(loop2,0); 
                  end;  
                end else begin  
                 if kursiv then  
                  begin 
                   s:=s+'</i>'; 
                   kursiv:=false;  
                   ReihenFolge.Move(loop2,ReihenFolge.Count-1);  
                  end;  
                end;

            3: if fsUnderline in Style then  
                begin
                 if not us then
                  begin 
                   s:=s+'<u>';
                   us:=true; 
                   ReihenFolge.Move(loop2,0);  
                  end;  
                 end else begin 
                  if us then 
                   begin
                    s:=s+'</u>'; 
                    us:=false;  
                    ReihenFolge.Move(loop2,ReihenFolge.Count-1); 
                   end; 
                 end;  

             4 : if Color<>aktcolor then  
                 begin
                  aktcolor:=color; 
                  s:=s+'</font><font size="'+ 
                  IntToStr(aktsize)+'" color="#'+ 
              IntToHex(GetRValue(AktColor),2)+  
              IntToHex(GetGValue(AktColor),2)+ 
              IntToHex(GetBValue(AktColor),2)+'">';
                  ReihenFolge.Move(loop2,0); 
                end;  

             5: if CalculateSize(Size)<>aktSize then 
                 begin 
                  aktsize:=CalculateSize(size); 
                  s:=s+'</font><font size="'+IntToStr(aktsize)+'">'; 
                  ReihenFolge.Move(loop2,0); 
                 end;

             6: if Source.Paragraph.Numbering =nsBullet then 
                 begin 
                  if not bullet then 
                   begin 
                    s:=s+'<li>'; 
                    bullet:=true;  
                    ReihenFolge.Move(loop2,0); 
                   end;
                 end else begin 
                  if bullet then 
                    begin 
//                     s:=s+'</li>'; 
                     bullet:=false; 
                     ReihenFolge.Move(loop2,ReihenFolge.Count-1); 
                   end; 
                  end;

       end; // case 

      end; // with selattributes do 


      // jetzt wird erst mal alles ges?ubert, was in der HTM-Datei nicht so nett 
      // aussehen würde 
      if source.SelText='"' then 
        s:=s+'&quot;' 
       else 
      if source.SelText='<' then  
        s:=s+'&lt;'  
       else 
      if source.SelText='>' then
        s:=s+'&gt;'
       else  
      if source.SelText='?' then 
        s:=s+'&auml;' 
       else 
      if source.SelText='?' then 
        s:=s+'&Auml;' 
       else  
      if source.SelText='?' then
        s:=s+'&ouml;' 
       else
      if source.SelText='?' then  
        s:=s+'&Ouml;' 
       else  
      if source.SelText='ü' then  
        s:=s+'&uuml;' 
       else 
//      if source.SelText='U' then
//        s:=s+'&Uuml;'
//       else 
      if source.SelText='?' then 
        s:=s+'&szlig;' 
       else 
        s:=s+Source.SelText;  
    end; // jedes zeichen 

     // Zum Abschlu? schlie?en wir die ganzen Tags nochmal 
     for loop2:=0 to ReihenFolge.Count-1 do 
      case Integer(Reihenfolge[loop2]) of 
       1: if fett then s:=s+'</b>'; 
       2: if kursiv then s:=s+'</i>'; 
       3: if us then s:=s+'</u>';
       4: s:=s+'</font>';
//       6: s:=s+'</li>'; 
      end; // case 

      // der letzte Paragraph wird geschlossen
    //s:=s+'</p>'; 

   // jetzt leerzeichen raus
   for loop:=100 downto 2 do
    begin
     s2:='';
     for loop2:=1 to loop do
      s2:=s2+' ';
     s:=StringReplace(s,s2,'<!--'+IntToStr(loop)+'-->',
                       [rfReplaceAll,rfIgnoreCase]);
    end;
   for loop:=100 downto 2 do
    begin
     s2:='';
     for loop2:=1 to loop do
      s2:=s2+'&nbsp;';
     s:=StringReplace(s,'<!--'+IntToStr(loop)+'-->',s2,
                       [rfReplaceAll,rfIgnoreCase]);
    end;

   // jetzt sind wir fertig
   //s:=s+'</html>';
   result:=s;
   Reihenfolge.free;

   Source.Width:=SourceWidth;
   Source.Visible:=true;
end;
end.
