CON

  _clkmode = xtal1 + pll16x     'Use the PLL to multiple the external clock by 16
  _xinfreq = 5_000_000          'An external clock of 5MHz. is used (80MHz. operation)

  LOOPSIZE = 510
  NUMLOOPS = 2000
 
OBJ

  server : "WebServer"         
  PST    : "Parallax Serial Terminal.spin"

VAR

  long numRead

  byte cmdBuffer[4]
  byte tmpBuffer[1024*4]
  byte inpBuffer[1024*4]

  byte buf2K[2048]
   
PUB main

  server.PauseMSec(2_000)              'A small delay to allow time to switch to the terminal application after loading the device
  
  PST.Start(115_200) 
  PST.Home
  PST.Clear
  PST.Str(string("Started.",13))
  
  server.init   ' Initialize the WIZNET chip

  PST.Str(string("WIZNET started.",13))

  loop   
                
PRI loop | p, q, c


' 1 ss 00 ddddddddd...    Store ddddd into buffer
' 2 nn ss                 Write from buffer nn=numloops ss=loopsize   return zzzz (FACE=ok, DEAD=bad)
' 3 nn ss                 Read and compare to buffer nn=numloops ss=loopsize


  repeat
  
    PST.Str(string("Waiting on connection ... ")) 
    server.getConnection                          
    PST.Str(string("connected",13))

    repeat
      PST.Str(string("Reading command.",13))
      p := server.getPacket(@numRead)
      if p==0
        PST.Str(string("Socket error.",13))
        quit
        
      if numRead<>5
        PST.Str(string("Command was "))
        PST.dec(numRead)
        PST.Str(string(" bytes (not 5)",13))
        quit

      PST.Str(string("Got a command.",13))

      case byte[p]
        1     : PST.Str(string("Store dddd into buffer",13))
        2     : PST.Str(string("Write from buffer",13))
        3     : PST.Str(string("Read to buffer",13))
        other : PST.Str(string("Unknown command",13))
                quit
            

  

    ' 20 second delay
    server.pauseMSec(2_000)
            
    server.disconnectSocket
    server.pauseMSec(250)
    'p := server.getSocketStatus
    'PST.Str(string("Status:"))
    'PST.hex(p,2)
    'PST.Str(string(13))   
    server.closeSocket
    server.pauseMSec(2_000)
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
