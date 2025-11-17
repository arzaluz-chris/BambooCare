{\rtf1\ansi\ansicpg1252\cocoartf2865
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\froman\fcharset0 Times-Bold;\f1\froman\fcharset0 Times-Roman;\f2\fmodern\fcharset0 Courier;
}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue233;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;\cssrgb\c0\c0\c93333;}
{\*\listtable{\list\listtemplateid1\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid1\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid1}
{\list\listtemplateid2\listhybrid{\listlevel\levelnfc0\levelnfcn0\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{decimal\}}{\leveltext\leveltemplateid101\'01\'00;}{\levelnumbers\'01;}\fi-360\li720\lin720 }{\listname ;}\listid2}
{\list\listtemplateid3\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid201\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid3}}
{\*\listoverridetable{\listoverride\listid1\listoverridecount0\ls1}{\listoverride\listid2\listoverridecount0\ls2}{\listoverride\listid3\listoverridecount0\ls3}}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sa321\partightenfactor0

\f0\b\fs48 \cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Proyecto: BambooCare (iOS App)\
\pard\pardeftab720\sa298\partightenfactor0

\fs36 \cf0 1. Concepto del Proyecto\
\pard\pardeftab720\sa240\partightenfactor0

\fs24 \cf0 BambooCare
\f1\b0  es una aplicaci\'f3n nativa de iOS (SwiftUI) dise\'f1ada para ser el asistente definitivo en el cuidado de plantas de bamb\'fa. La aplicaci\'f3n ofrece seguimiento personalizado, recordatorios de riego inteligentes basados en el clima y una gu\'eda de referencia para mantener las plantas sanas.\
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 2. Prop\'f3sito y Audiencia\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa240\partightenfactor0
\ls1\ilvl0
\fs24 \cf0 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Problema:
\f1\b0  El cuidado del bamb\'fa (especialmente el bamb\'fa de la suerte en interiores o variedades de jard\'edn) es un desaf\'edo. Los usuarios no saben con qu\'e9 frecuencia regar, cu\'e1nta agua usar, o c\'f3mo diagnosticar problemas comunes (hojas amarillas, plagas).\
\ls1\ilvl0
\f0\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Soluci\'f3n:
\f1\b0  BambooCare ofrece orientaci\'f3n personalizada basada en la especie de bamb\'fa del usuario, su ubicaci\'f3n (interior/exterior) y las condiciones clim\'e1ticas locales.\
\ls1\ilvl0
\f0\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Audiencia:
\f1\b0  Propietarios de bamb\'fa, desde principiantes con un solo "bamb\'fa de la suerte" hasta entusiastas con m\'faltiples variedades en interiores o exteriores.\
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 3. Estructura de la Aplicaci\'f3n (Navegaci\'f3n)\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs24 \cf0 La aplicaci\'f3n se estructurar\'e1 principalmente en tres pesta\'f1as (un 
\f2\fs26 TabView
\f1\fs24  de SwiftUI):\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa240\partightenfactor0
\ls2\ilvl0
\f0\b \cf0 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	1	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Mis Bamb\'fas (Principal):
\f1\b0  El dashboard donde el usuario ve todas sus plantas registradas y su estado de riego.\
\ls2\ilvl0
\f0\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	2	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Gu\'eda de Cuidados:
\f1\b0  Una biblioteca de referencia sobre enfermedades, plagas y consejos generales.\
\ls2\ilvl0
\f0\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	3	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Ajustes:
\f1\b0  Configuraci\'f3n de notificaciones, unidades (m\'e9trico/imperial) y gesti\'f3n de la ubicaci\'f3n.\
\pard\pardeftab720\sa298\partightenfactor0

\f0\b\fs36 \cf0 4. Documentos del Proyecto\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa240\partightenfactor0
\ls3\ilvl0
\f1\b0\fs24 \cf3 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}{\field{\*\fldinst{HYPERLINK "https://www.google.com/search?q=./FEATURES.md"}}{\fldrslt \expnd0\expndtw0\kerning0
\ul \outl0\strokewidth0 \strokec3 Features.md}}\cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 : Descripci\'f3n detallada de las funcionalidades.\
\ls3\ilvl0\cf3 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}{\field{\*\fldinst{HYPERLINK "https://www.google.com/search?q=./DESIGN.md"}}{\fldrslt \expnd0\expndtw0\kerning0
\ul \outl0\strokewidth0 \strokec3 Design.md}}\cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 : Gu\'eda de estilo visual, UI/UX y filosof\'eda de dise\'f1o.\
\ls3\ilvl0\cf3 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}{\field{\*\fldinst{HYPERLINK "https://www.google.com/search?q=./TECHNICAL_SPECS.md"}}{\fldrslt \expnd0\expndtw0\kerning0
\ul \outl0\strokewidth0 \strokec3 Technical_Specs.md}}\cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 : Especificaciones t\'e9cnicas, APIs, permisos y modelos de datos.\
}