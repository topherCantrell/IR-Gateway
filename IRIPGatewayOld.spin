

CON

  _clkmode = xtal1 + pll16x     'Use the PLL to multiple the external clock by 16
  _xinfreq = 5_000_000          'An external clock of 5MHz. is used (80MHz. operation)
                                    
  IN_PIN     = 24  ' Sensor input
  OUT_PIN    = 25  ' IR LED output
  'UNUSED    = 26  ' Unused I/O      
  NOTICE_PIN = 27  ' Visible LED output  

  SAMPLES_SIZE    = 1024*8  ' Size of the sample data
  REQUEST_SIZE    = 1024    ' Size of the decoded request map
  RESPONSE_SIZE   = 1024    ' Size of the outgoing response map
  INDEX_SIZE      = 256     ' Size of the browser-to-index-file map
  LONG_NAME_SIZE  = 512     ' Size of the long-file-name-to-short map
  CONTENTMAP_SIZE = 512     ' Size of the file-extension-to-content-type map

OBJ

  'map    : "StringKeyMap"      ' OBEX Using lots of maps. This is the common handling code (no data).  
  'IR     : "IRPlayRecord"      ' OBEX The infrared record/playback driver
  'STR    : "String"            ' String processing code (no data).    

  ' From the community
  server : "WebServer"         ' COMMUNITY Wait for a request and return a response
  'SDCard : "SD2.0_FATWrapper"  ' COMMUNITY Access to the SD card 

  ' Parallax library
  PST    : "Parallax Serial Terminal.spin"

VAR

{
  byte longNameMap[LONG_NAME_SIZE]  ' The mapping of long-file-names to short
  byte requestMap[REQUEST_SIZE]     ' The incoming request map
  byte responseMap[RESPONSE_SIZE]   ' The outgoing response map
  byte irSamples[SAMPLES_SIZE]      ' Database of named IR sequences
  byte contentMap[CONTENTMAP_SIZE]  ' Mapping of file-extension to content-type
  byte indexMap[INDEX_SIZE]         ' Map of browser-type to index.htm file
  byte sampleBuffer[512]            ' Temporary IR sequence recording buffer
  byte smallTmp[16]                 ' Small buffer for converting numbers to strings

  long  fileErrorHandle             ' SDCard file handle

' Command box to talk to IRPlayRecord cog        
  long command                      ' Command to IR engine (values 1 or 2)
  long paramError                   ' Additional command parameters
  long bufPtr                       ' Pointer to play/record temporary buffer

  long defaultContentType           ' Pointer to default content-type for unknown file types
  }
  
PUB main

  server.PauseMSec(2_000)              'A small delay to allow time to switch to the terminal application after loading the device
  
  PST.Start(115_200) 
  PST.Home
  PST.Clear
  PST.Str(string("Started",13))
  
  server.init   ' Initialize the WIZNET chip

  PST.Str(string("WIZNET started",13))

  loop   
                
PRI loop | p, q, c

  ' Infinite server loop
  repeat
  
    PST.Str(string("Waiting",13))

    server.getConnection

    PST.Str(string("Connected",13))

    repeat c from 0 to 5000
      server.txTCP(@packet,510)

    server.pauseMSec(20000)

    ' Wait for a request
    'p := server.getPacket   
    'if p<> 0                         
            
      
    server.disconnectSocket
    server.pauseMSec(250)
    'p := server.getSocketStatus
    'PST.Str(string("Status:"))
    'PST.hex(p,2)
    'PST.Str(string(13))   
    server.closeSocket
    server.pauseMSec(250)
    'p := server.getSocketStatus
    'PST.Str(string("Status:"))
    'PST.hex(p,2)
    'PST.Str(string(13))    
    server.openSocketAndListen
    server.pauseMSec(250)
    'p := server.getSocketStatus
    'PST.Str(string("Status:"))
    'PST.hex(p,2)
    'PST.Str(string(13))  
  

PRI loop2 | p, q



 {
  ' Start the SD card and mount the filesystem
  SDCard.Start
  server.PauseMSec(500)
  SDCard.mount(fileErrorHandle)      

  ' Start the IR engine
  paramError:= (NOTICE_PIN<<16) | (OUT_PIN<<8) | IN_PIN  ' Output/Input pin numbers
  command:=1               ' Driver clears after init
  IR.start(@command)       ' Start the IRPlayRecord
  repeat while command<>0  ' Wait for driver to start

  ' Initialize the various maps
  map.new(@irSamples,SAMPLES_SIZE)
  map.new(@requestMap,REQUEST_SIZE)
  map.new(@responseMap,RESPONSE_SIZE) 
  map.new(@indexMap,INDEX_SIZE)
  map.new(@contentMap,CONTENTMAP_SIZE)
  map.new(@longNameMap,LONG_NAME_SIZE)

  ' Read the index-map and content-map from text files
  readStringMap(string("index.txt"),@indexMap)
  readStringMap(string("content.txt"),@contentMap)
  readStringMap(string("longname.txt"),@longNameMap)

  'dumpMapStrings(@longNameMap)

  ' Read the IR sample database map (as binary)
  readSamplesFromDisk
  'writeSamplesToDisk ' To clear file

  ' Cache the default unknown file content type
  defaultContentType := map.get(@contentMap,string("*"))
}


  ' Infinite server loop
  repeat

    ' Wait for a request
    p := server.getPacket   
    if p<> 0

      PST.Str(string("Connected",13))

      {
      ' parse the data from the header into a map
      decodeHTTPBuffer(@requestMap, p)    
      'dumpMapStrings(@requestMap)

      ' Any request can have play/record/store/delete requests in the URL
      q := map.get(@requestMap,string("#irPlay"))
      if q<> 0
        irPlayMulti(q)
      q := map.get(@requestMap,string("#irRecord"))
      if q<> 0
        irRecord
      q := map.get(@requestMap,string("#irStore"))
      if q<> 0
        irStore(q)
      q := map.get(@requestMap,string("#irDelete"))
      if q<> 0
        irDelete(q)

      ' URL: getSampleList  - return the list of IR sequence names
      ' URL: other          - return the requested file or 404
      q := map.get(@requestMap,string("*url"))
      if STR.equals(q,string("/getSampleList"))
        getSampleList
      elseif STR.equals(q,string("/quick"))
        getQuick
      else
        getFile(q)
    }
      
    server.disconnectSocket
    server.pauseMSec(250)
    'p := server.getSocketStatus
    'PST.Str(string("Status:"))
    'PST.hex(p,2)
    'PST.Str(string(13))   
    server.closeSocket
    server.pauseMSec(250)
    'p := server.getSocketStatus
    'PST.Str(string("Status:"))
    'PST.hex(p,2)
    'PST.Str(string(13))    
    server.openSocketAndListen
    server.pauseMSec(250)
    'p := server.getSocketStatus
    'PST.Str(string("Status:"))
    'PST.hex(p,2)
    'PST.Str(string(13))  

' QUICK because it just returns a very short header. Rich clients can use "/quick" to
' send ir parameters without invoking the filesystem.
PRI getQuick
  server.StringSend(string("HTTP/1.1 200 OK",13,10,"Content-type: text",13,10,"Content-length: 2",13,10,13,10,"OK"))

  {  
PUB decodeHTTPBuffer(mapStructure,p)  | q, i, c, u
'
'' This function parses an HTTP request into a Map<String,String>. The
'' pieces of the request can then be accessed by name.
''   *method   - the HTTP method (GET, POST, etc)
''   *url      - the requested URL (doesn't include any parameters)
''   *http     - the HTTP version
''   #         - URL parameters are added to the map with each key prefixed by '#'
''   $         - POST parameters are added to the map with each key prefixed by '$'
'' @mapStructure  pointer to the map to fill
'' @p             pointer to the HTTP packet buffer

  ' Make sure nothing lingers from before
  map.clear(mapStructure)

  ' The method is the 1st word  
  q := STR.findCharacter(p," ")
  byte[q] :=0
  map.put(mapStructure, string("*method"), p)    

  ' The URL is the second word
  p:=q+1                                      
  q:= STR.findCharacter(p," ")   
  byte[q] :=0    

  ' Decode any parameters in the URL
  i := STR.findCharacter(p,"?")
  if i<>0
    byte[q]:="&"  ' Force an entry separator
    c:=byte[q+1]  ' Remember this
    byte[q+1]:=0    ' Force an end of list
    ' Put all parameters in the map
    decodeKeyValueSet(mapStructure,i+1,"#","&","=")                  
    byte[q+1]:=c ' Restore the forced end-of-list character    
    byte[i]:=0   ' Terminate the URL before the parameters. 
    byte[q]:=0   ' Restore the end-of-url marker

  map.put(mapStructure, string("*url"),p)
  p:=q+1  

  ' The HTTP version is the rest of the line
  q:= STR.findCharacter(p,$0A)
  byte[q] :=0
  if byte[q-1]==$0D
    byte[q-1]:=0
  map.put(mapStructure, string("*http"),p)
  p:=q+1                                        

  ' The HTTP headers
  q := STR.findCharacters(p,string($0D,$0A,$0D,$0A))
  if q<>0
    q := q+2
    u := q+2
  else
    q := STR.findCharacters(p,string($0A,$0A))+1
    u := q+1        
  byte[q]:=0
  decodeKeyValueSet(mapStructure,p,0,$0A,":")

  p := u 
  if byte[p]<>0
    decodeKeyValueSet(mapStructure,p,"$","&","=")
    p := u  
 
PUB decodeKeyValueSet(mapStructure,p,prefixChar,eoeChar,sepChar) | q, u, c
'
'' This function decodes a list of key/value pairs and adds them to the given map.
'' @mapStructure pointer to the map to fill out
'' @p           pointer to the list in memory
'' @prefixChar  the prefix character to add to every key (or 0 for none)
'' @eoeChar     the character that marks the end of each entry in the list
'' @speChar     the character that separates the key and value of each entry

  repeat
    ' A null terminates the list
    if byte[p]==0
      return
    ' Assume there is a separator. Make the key string.
    q:= STR.findCharacter(p,sepChar)
    byte[q]:=0
    ' Assume there is an end marker. Make the value string.
    ++q
    ' Find the next end-of-entry (might be end of string)
    u:= STR.findCharacter(q,eoeChar)
    if(u==0)
      u:=q+strsize(q)
    byte[u]:=0
    ' Trim the key and value
    p:= STR.trimCharacters(p)
    q:= STR.trimCharacters(q)
    if prefixChar<>0
      --p
      byte[p]:=prefixChar      
    ' Add key/value strings to the map
    map.put(mapStructure,p,q)
    ' Next in list
    p := u+1             

PUB dumpMapStrings(mapStructure) | x, i, p
'
'' This function dumps the contents of the map as string/string.
'' WARNING: Only null-terminated string values in the map!
'' @mapStructure pointer to the map data structure

  x := map.countEntries(mapStructure)
  PST.Str(string("There are "))
  PST.Dec(x)
  PST.Str(string(" entries.",13))
  if x==0
    return
  repeat i from 0 to (x-1)
    p:=map.getKey(mapStructure,i)
    PST.Str(string(" '"))
    PST.Str(p)
    PST.Str(string("' = '"))
    p:=map.getValue(mapStructure,i)
    PST.Str(p)
    PST.Str(String("'",13))                 


PRI irPlayMulti(s) | p,c

  repeat
    p := STR.findCharacter(s,":")
    if p==0
      irPlay(s)
      return
    else
      byte[p] :=0
      irPlay(s)
      s:=p+1
      server.pauseMSec(1000)

PRI irPlay(s) | c
' Play the requested IR sequence (s)
  'debugStr(string("irPlay:"))
  'debugStr(s)
  'debugStr(string(13))

  ' Allow for pauses
  if byte[s] == "@"
    c := STR.decimalToNumber(s+1)
    server.pauseMSec(c)
    return
  
  repeat while command<>0
  c := map.getBinary(@irSamples,s)
  if c==0
      'debugStr(string("Unknown sequence "))
      'debugStr(s)
      'debugStr(string(13))
  else
      bufPtr:=c
      command:=2         

PRI irRecord
' Record an IR sequence to the temp buffer
  'debugStr(string("irRecord")) 
  repeat while command<>0
  map.writeWordToMemory(@sampleBuffer,510)             
  bufPtr:=@sampleBuffer
  command:=1                             

PRI irStore(s)
' Store the recorded IR sequence to the database with the name (s)
  PST.Str(string("irStore:"))
  PST.Str(s)
  PST.Str(string(":"))
  PST.Dec(map.readWordFromMemory(@sampleBuffer))
  PST.Str(string(":",13))

  map.putBinary(@irSamples,s,@sampleBuffer+2,map.readWordFromMemory(@sampleBuffer))
  ' Update the disk file
  writeSamplesToDisk

PRI irDelete(s)
' Delete the IR sequence (s)
  'debugStr(string("irDelete:"))
  'debugStr(s)
  'debugStr(string(13))
  repeat while command<>0
  map.remove(@irSamples,s)
  writeSamplesToDisk

PUB readStringMap(name,mapStructure) | c, p
'
'' This function reads a text file of key/value pairs into a map structure.
'' Each line is a key/value pair separated with a space.
''   @name the name of the file (in the root dirctory)
''   @mapStructure the structure to fill
'
   SDCard.changeDirectory(string("/"))
   SDCard.openFile(name, "r")
   c := SDCard.getFileSize
   p := @requestMap+2
   SDCard.readFromFile(p,c)
   SDCard.closeFile
   byte[p+c] := 0
   byte[p+c+1] := 0
   decodeKeyValueSet(mapStructure,p,0,$0A," ")
   'debugStr(name)
   'debugStr(string(13))
   'dumpMapStrings(mapStructure)
 
PRI getSampleList | p, c, i
  ' This function generates the dynamic web content: the list of IR sequence names.
  server.StringSend(string("HTTP/1.1 200 OK"))
  server.StringSend(string(13, 10))
       
  server.StringSend(string("Connection: close"))
  server.StringSend(string(13, 10))
  server.StringSend(string("Content-Type: text/html"))
  server.StringSend(string(13, 10))      
  server.StringSend(string(13, 10))     

  server.StringSend(@dynamicTop)   

  c:=map.countEntries(@irSamples)
  
  if c<>0
    repeat i from 0 to (c-1)
      p := map.getEntry(@irSamples,i)
      server.StringSend(@dynamicT1)
      server.StringSend(p)
      server.StringSend(@dynamicT2)
      server.StringSend(p)
      server.StringSend(@dynamicT3)
      server.StringSend(p)
      server.StringSend(@dynamicT4)
    
  server.StringSend(@dynamicBottom)

PRI FileExists(fileToCompare) | filenamePtr
' This was taken from demo community code.

  'Start file find at the top of the list
  SDCard.startFindFile
  
  'Verify that the file exists
  filenamePtr := 1
  repeat while filenamePtr <> 0
    filenamePtr := SDCard.nextFindFile
    if STR.equals(fileToCompare,filenamePtr)
      return true

  return false  


PRI changeDirectory(p) : i
' This function processes a file path and changes into all of
' the subdirectories. A leading "/" is optional, but the
' traversal always starts with the root directory.
' This was taken from demo community code.

  ' Start at the root of the filesystem
  SDCard.changeDirectory(string("/"))
  if byte[p]=="/"
    ++p

  return p

  {
  ' Change into each subdirectory
  repeat
    i := STR.findCharacter(p,"/")
    if i==0
      return p
    byte[i] := 0
    SDCard.changeDirectory(p)
    p:=i+1
  }
    
PRI getFile(s) | p, c, q, o, i, t
' This function sends the contents of the requested file to the browser.
' If the name is "/" then the browser type is used to select the proper index.htm
' entry page. Otherwise the file is loaded from the SD card.


  ' For "/" find the right entry

  
  if STR.equals(s,string("/"))
    ' This is the default index if there are no matches
    s := string("index.htm")

    ' The browser identifies itself here
    p := map.get(@requestMap,string("User-Agent"))

    ' Look for a "contains" match from the index-map
    c := map.countEntries(@indexMap)
    repeat i from 0 to (c-1)
      q := map.getKey(@indexMap,i)    
      o := STR.findCharacters(p,q)
      if o<> 0
        s := map.getValue(@indexMap,i)


  ' Handle any subdirectories and long-names


  s:= changeDirectory(s)
  
  ' Rather than implement full long-name processing on the FAT filesystem we
  ' will just manually map a few known long-names to short ones. These are
  ' referenced by the flash-player and can't be changed easily.
  q := STR.findCharacterFromEnd(s,".")
  if(q<>0)
    q := q-s
  if(q>7)
    q := map.get(@longNameMap,s)
    PST.Str(string(":"))
    PST.Str(s)
    PST.Str(string(":"))
    PST.Str(q)
    PST.Str(string(":",13))
    if q<>0
      s := q

  ' Everything is upper case in FAT (for find-file string compares)
  STR.charactersToUpperCase(s)

  PST.Str(string("Requested:"))
  PST.Str(s)
  PST.Str(string(":",13))


  ' Get the content-type

  
  ' Get the content-type (or use the "unknown" default type)
  t := defaultContentType
  c := map.countEntries(@contentMap)
  repeat i from 0 to (c-1)
    p := map.getKey(@contentMap,i)    
    o := STR.findCharacters(s,p)
    if o<> 0
      t := map.getValue(@contentMap,i)  


  ' 404 if the file is not found
      
  ' We are going to add return headers here
  map.clear(@responseMap)       
    
  ifnot(FileExists(s))
    'send 404 error
    'debugStr(string("404:"))
    'debugStr(s)
    'debugStr(string(":",13))
    p := string("<HTML><HEAD><TITLE>404</TITLE></HEAD><BODY>Not Found</BODY></HTML>")
    map.put(@responseMap,string("*code"),string("HTTP/1.1 404 Not Found"))
    map.put(@responseMap,string("_Content-Length"),string("66"))
    map.put(@responseMap,string("_Content-Type"),string("text/html")) 
    writeResponseHeader(@responseMap)
    server.StringSend(p)
    return

    
  ' Send the file data
    
    
  PST.Str(string("Sending:"))
  PST.Str(s)
  PST.Str(string(": ... "))
  
  map.put(@responseMap,string("*code"),string("HTTP/1.1 200 OK"))
  map.put(@responseMap,string("_Content-Type"),t)
     
  ' Open the file for reading
  SDCard.openFile(s, "r")
  i := SDCard.getFileSize

  p := STR.numberToString(i,@smallTmp)
  map.put(@responseMap,string("_Content-Length"),p)

  'dumpMapStrings(@responseMap)
  writeResponseHeader(@responseMap)

  'c:=0

  ' Send as many full chunks as we can
  repeat while i>(REQUEST_SIZE-2)
    SDCard.readFromFile(@requestMap+2, REQUEST_SIZE-2)    
    server.txTCP(@requestMap+2, REQUEST_SIZE-2)
    'repeat p from 0 to((REQUEST_SIZE-2)-1)
    '  c := c + byte[@requestMap+2+p]
    i := i - (REQUEST_SIZE-2)
    
  ' Send any partial chunck remaining
  if i>0
    SDCard.readFromFile(@requestMap+2, i)
    server.txTCP(@requestMap+2, i)
    'repeat p from 0 to(i-1)
    '  c := c + byte[@requestMap+2+p]

  'PST.dec(c)
  
  ' Close the file        
  SDCard.closeFile

  PST.Str(string("File sent.",13))     

PUB writeResponseHeader(mapStructure) | p, i, c
'
'' This function sends the HTTP response headers stored in the map.
'' The entry "*code" contains the first line ... the status code.
'' All other entries to send must begin with "_".
''   @mapStructure the map containing the headers
'
  p := map.get(mapStructure,string("*code"))
  server.StringSend(p)
  server.StringSend(string($0D, $0A)) 

  c:=map.countEntries(mapStructure)
  repeat i from 0 to (c-1)
    p:=map.getKey(mapStructure,i)
    if byte[p]=="_"
      server.StringSend(p+1)
      server.StringSend(string(": "))
      server.StringSend(map.getValue(mapStructure,i))
      server.StringSend(string($0D, $0A))

  server.StringSend(string($0D, $0A))

PRI writeSamplesToDisk

  ' The map is written very infrequently   

  SDCard.changeDirectory(string("/"))     
  SDCard.openFile(string("samples.bin"), "w")
  SDCard.writeData(@irSamples,SAMPLES_SIZE)
  SDCard.flushData
  SDCard.closeFile                      
  PST.Str(string("Wrote sample map to disk: "))
  PST.Dec(map.readWordFromMemory(@irSamples+2))
  PST.Str(string(13))

PRI readSamplesFromDisk | p        

  ' The map is read once at startup

  map.clear(@irSamples)              
  
  SDCard.changeDirectory(string("/"))     
  SDCard.openFile(string("samples.bin"), "r")
  SDCard.readFromFile(@irSamples,SAMPLES_SIZE)
  SDCard.closeFile
  'debugStr(string("Read sample map from disk ("))
  'debugDec(map.countEntries(@irSamples))
  'debugStr(string(")",13))

DAT

dynamicTop
byte "<html>"
byte "<head><title>IR Samples</title></head>"
byte "<body>"
byte "<h1>IR Samples</h1>"
byte "<table border=",34,"1",34,">"
byte 0                         

dynamicT1
byte "<tr><td><input type=",34,"button",34," value=",34,"Delete",34," onclick=",34,"location.href='getSampleList?irDelete=",0
dynamicT2
byte "';",34,"/>"
byte "</td><td><input type=",34,"button",34," value=",34,"Test",34," onclick=",34,"location.href='getSampleList?irPlay=",0
dynamicT3
byte "';",34,"/>"
byte "</td><td>",0
dynamicT4
byte "</td></tr>",0

dynamicBottom
byte "</table>"
byte "<p>"
byte "<input type=",34,"button",34," value=",34,"Add",34," onClick=",34,"location.href='samprec.htm?irRecord=1';",34,"/>"
byte "<input type=",34,"button",34," value=",34,"Back",34," onClick=",34,"location.href='/';",34,"/>"
byte "</p>"
byte "</body>"
byte "</html>"
byte 0
}

DAT
packet ' 510 bytes ... like when I had trouble before
 byte "00CDEFGHIJKLMNOPQRSTUVWXYZ0123456789@abcdefghijklmnopqrstuvwxyz",13
 byte "11CDEFGHIJKLMNOPQRSTUVWXYZ0123456789@abcdefghijklmnopqrstuvwxyz",13
 byte "22CDEFGHIJKLMNOPQRSTUVWXYZ0123456789@abcdefghijklmnopqrstuvwxyz",13
 byte "33CDEFGHIJKLMNOPQRSTUVWXYZ0123456789@abcdefghijklmnopqrstuvwxyz",13
 byte "44CDEFGHIJKLMNOPQRSTUVWXYZ0123456789@abcdefghijklmnopqrstuvwxyz",13
 byte "55CDEFGHIJKLMNOPQRSTUVWXYZ0123456789@abcdefghijklmnopqrstuvwxyz",13
 byte "66CDEFGHIJKLMNOPQRSTUVWXYZ0123456789@abcdefghijklmnopqrstuvwxyz",13
 byte "77CDEFGHIJKLMNOPQRSTUVWXYZ0123456789@abcdefghijklmnopqrstuvwxyz",13
 ' Visualize any overflow
 byte "################################################################"

