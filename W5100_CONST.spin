CON

  '***************************************
  '  W5100 Common Register Definitions
  '***************************************
  _MR           = $0000         'Mode Register
  _GAR0         = $0001         'Gateway Address Register
  _GAR1         = $0002
  _GAR2         = $0003
  _GAR3         = $0004
  _SUBR0        = $0005         'Subnet Mask Address Register
  _SUBR1        = $0006
  _SUBR2        = $0007
  _SUBR3        = $0008
  _SHAR0        = $0009         'Source Hardware Address Register (MAC)
  _SHAR1        = $000A
  _SHAR2        = $000B
  _SHAR3        = $000C
  _SHAR4        = $000D
  _SHAR5        = $000E
  _SIPR0        = $000F         'Source IP Address Register
  _SIPR1        = $0010
  _SIPR2        = $0011
  _SIPR3        = $0012
  'Reserved space $0013 - $0014
  _IR           = $0015         'Interrupt Register
  _IMR          = $0016         'Interrupt Mask Register
  _RTR0         = $0017         'Retry Time Register
  _RTR1         = $0018
  _RCR          = $0019         'Retry Count Register
  _RMSR         = $001A         'Rx Memory Size Register
  _TMSR         = $001B         'Tx Memory Size Register
  _PATR0        = $001C         'Authentication Type in PPPoE Register
  _PATR1        = $001D
  'Reserved space $001E - $0027
  _PTIMER       = $0028         'PPP LCP Request Timer
  _PMAGIC       = $0029         'PPP LCP Magic Number
  _UIPR0        = $002A         'Unreachable IP Address Register
  _UIPR1        = $002B
  _UIPR2        = $002C
  _UIPR3        = $002D
  _UPORT0       = $002E         'Unreachable Port Register
  _UPORT1       = $002F
  'Reserved space $0030 - $03FF

  '***************************************
  '  W5100 Socket 0 Register Definitions
  '***************************************
  _S0_MR        = $0400         'Socket 0 Mode Register
  _S0_CR        = $0401         'Socket 0 Command Register
  _S0_IR        = $0402         'Socket 0 Interrupt Register
  _S0_SR        = $0403         'Socket 0 Status Register
  _S0_PORT0     = $0404         'Socket 0 Source Port Register
  _S0_PORT1     = $0405
  _S0_DHAR0     = $0406         'Socket 0 Destination Hardware Address Register
  _S0_DHAR1     = $0407
  _S0_DHAR2     = $0408
  _S0_DHAR3     = $0409
  _S0_DHAR4     = $040A
  _S0_DHAR5     = $040B
  _S0_DIPR0     = $040C         'Socket 0 Destination IP Address Register
  _S0_DIPR1     = $040D
  _S0_DIPR2     = $040E
  _S0_DIPR3     = $040F
  _S0_DPORT0    = $0410         'Socket 0 Destination Port Register
  _S0_DPORT1    = $0411
  _S0_MSSR0     = $0412         'Socket 0 Maximum Segment Size Register
  _S0_MSSR1     = $0413
  _S0_PROTO     = $0414         'Socket 0 Protocol in IP Raw Mode Register
  _S0_TOS       = $0415         'Socket 0 IP TOS Register
  _S0_TTL       = $0416         'Socket 0 IP TTL Register
  'Reserved space $0417 - $041F
  _S0_TX_FSRO   = $0420         'Socket 0 TX Free Size Register
  _S0_TX_FSR1   = $0421
  _S0_TX_RD0    = $0422         'Socket 0 TX Read Pointer Register
  _S0_TX_RD1    = $0423
  _S0_TX_WR0    = $0424         'Socket 0 TX Write Pointer Register
  _S0_TX_WR1    = $0425
  _S0_RX_RSR0   = $0426         'Socket 0 RX Received Size Register
  _S0_RX_RSR1   = $0427
  _S0_RX_RD0    = $0428         'Socket 0 RX Read Pointer Register
  _S0_RX_RD1    = $0429
  'Reserved space $042A - $04FF

  '***************************************
  '  W5100 Socket 1 Register Definitions
  '***************************************
  _S1_MR        = $0500         'Socket 1 Mode Register
  _S1_CR        = $0501         'Socket 1 Command Register
  _S1_IR        = $0502         'Socket 1 Interrupt Register
  _S1_SR        = $0503         'Socket 1 Status Register
  _S1_PORT0     = $0504         'Socket 1 Source Port Register
  _S1_PORT1     = $0505
  _S1_DHAR0     = $0506         'Socket 1 Destination Hardware Address Register
  _S1_DHAR1     = $0507
  _S1_DHAR2     = $0508
  _S1_DHAR3     = $0509
  _S1_DHAR4     = $050A
  _S1_DHAR5     = $050B
  _S1_DIPR0     = $050C         'Socket 1 Destination IP Address Register
  _S1_DIPR1     = $050D
  _S1_DIPR2     = $050E
  _S1_DIPR3     = $050F
  _S1_DPORT0    = $0510         'Socket 1 Destination Port Register
  _S1_DPORT1    = $0511
  _S1_MSSR0     = $0512         'Socket 1 Maximum Segment Size Register
  _S1_MSSR1     = $0513
  _S1_PROTO     = $0514         'Socket 1 Protocol in IP Raw Mode Register
  _S1_TOS       = $0515         'Socket 1 IP TOS Register
  _S1_TTL       = $0516         'Socket 1 IP TTL Register
  'Reserved space $0517 - $051F
  _S1_TX_FSRO   = $0520         'Socket 1 TX Free Size Register
  _S1_TX_FSR1   = $0521
  _S1_TX_RD0    = $0522         'Socket 1 TX Read Pointer Register
  _S1_TX_RD1    = $0523
  _S1_TX_WR0    = $0524         'Socket 1 TX Write Pointer Register
  _S1_TX_WR1    = $0525
  _S1_RX_RSR0   = $0526         'Socket 1 RX Received Size Register
  _S1_RX_RSR1   = $0527
  _S1_RX_RD0    = $0528         'Socket 1 RX Read Pointer Register
  _S1_RX_RD1    = $0529
  'Reserved space $052A - $05FF

  '***************************************
  '  W5100 Socket 2 Register Definitions
  '***************************************
  _S2_MR        = $0600         'Socket 2 Mode Register
  _S2_CR        = $0601         'Socket 2 Command Register
  _S2_IR        = $0602         'Socket 2 Interrupt Register
  _S2_SR        = $0603         'Socket 2 Status Register
  _S2_PORT0     = $0604         'Socket 2 Source Port Register
  _S2_PORT1     = $0605
  _S2_DHAR0     = $0606         'Socket 2 Destination Hardware Address Register
  _S2_DHAR1     = $0607
  _S2_DHAR2     = $0608
  _S2_DHAR3     = $0609
  _S2_DHAR4     = $060A
  _S2_DHAR5     = $060B
  _S2_DIPR0     = $060C         'Socket 2 Destination IP Address Register
  _S2_DIPR1     = $060D
  _S2_DIPR2     = $060E
  _S2_DIPR3     = $060F
  _S2_DPORT0    = $0610         'Socket 2 Destination Port Register
  _S2_DPORT1    = $0611
  _S2_MSSR0     = $0612         'Socket 2 Maximum Segment Size Register
  _S2_MSSR1     = $0613
  _S2_PROTO     = $0614         'Socket 2 Protocol in IP Raw Mode Register
  _S2_TOS       = $0615         'Socket 2 IP TOS Register
  _S2_TTL       = $0616         'Socket 2 IP TTL Register
  'Reserved space $0617 - $061F
  _S2_TX_FSRO   = $0620         'Socket 2 TX Free Size Register
  _S2_TX_FSR1   = $0621
  _S2_TX_RD0    = $0622         'Socket 2 TX Read Pointer Register
  _S2_TX_RD1    = $0623
  _S2_TX_WR0    = $0624         'Socket 2 TX Write Pointer Register
  _S2_TX_WR1    = $0625
  _S2_RX_RSR0   = $0626         'Socket 2 RX Received Size Register
  _S2_RX_RSR1   = $0627
  _S2_RX_RD0    = $0628         'Socket 2 RX Read Pointer Register
  _S2_RX_RD1    = $0629
  'Reserved space $062A - $06FF

  '***************************************
  '  W5100 Socket 3 Register Definitions
  '***************************************
  _S3_MR        = $0700         'Socket 3 Mode Register
  _S3_CR        = $0701         'Socket 3 Command Register
  _S3_IR        = $0702         'Socket 3 Interrupt Register
  _S3_SR        = $0703         'Socket 3 Status Register
  _S3_PORT0     = $0704         'Socket 3 Source Port Register
  _S3_PORT1     = $0705
  _S3_DHAR0     = $0706         'Socket 3 Destination Hardware Address Register
  _S3_DHAR1     = $0707
  _S3_DHAR2     = $0708
  _S3_DHAR3     = $0709
  _S3_DHAR4     = $070A
  _S3_DHAR5     = $070B
  _S3_DIPR0     = $070C         'Socket 3 Destination IP Address Register
  _S3_DIPR1     = $070D
  _S3_DIPR2     = $070E
  _S3_DIPR3     = $070F
  _S3_DPORT0    = $0710         'Socket 3 Destination Port Register
  _S3_DPORT1    = $0711
  _S3_MSSR0     = $0712         'Socket 3 Maximum Segment Size Register
  _S3_MSSR1     = $0713
  _S3_PROTO     = $0714         'Socket 3 Protocol in IP Raw Mode Register
  _S3_TOS       = $0715         'Socket 3 IP TOS Register
  _S3_TTL       = $0716         'Socket 3 IP TTL Register
  'Reserved space $0717 - $071F
  _S3_TX_FSRO   = $0720         'Socket 3 TX Free Size Register
  _S3_TX_FSR1   = $0721
  _S3_TX_RD0    = $0722         'Socket 3 TX Read Pointer Register
  _S3_TX_RD1    = $0723
  _S3_TX_WR0    = $0724         'Socket 3 TX Write Pointer Register
  _S3_TX_WR1    = $0725
  _S3_RX_RSR0   = $0726         'Socket 3 RX Received Size Register
  _S3_RX_RSR1   = $0727
  _S3_RX_RD0    = $0728         'Socket 3 RX Read Pointer Register
  _S3_RX_RD1    = $0729
  'Reserved space $072A - $07FF

  '***************************************
  '  W5100 Register Masks & Values Defintions
  '***************************************

  'Used in the mode register (MR)
  _RSTMODE      = %1000_0000    'If 1, internal registers are initialized
  _PBMODE       = %0001_0000    'Ping block mode, 1 is enabled
  _PPPOEMODE    = %0000_1000    'PPPoE mode, 1 is enabled
  _AIMODE       = %0000_0010    'Address auto-increment mode
  _INDMODE      = %0000_0001    'Indirect bus mode

  'Used in the Interrupt Register (IR) & Interrupt Mask Register (IMR)
  _CONFLICTM    = %1000_0000
  _UNREACHM     = %0100_0000
  _PPPoEM       = %0010_0000
  _S3_INTM      = %0000_1000    'Socket 3 interrupt bit mask (1 = interrupt)
  _S2_INTM      = %0000_0100    'Socket 2 interrupt bit mask (1 = interrupt)
  _S1_INTM      = %0000_0010    'Socket 1 interrupt bit mask (1 = interrupt)
  _S0_INTM      = %0000_0001    'Socket 0 interrupt bit mask (1 = interrupt)

  'Used in the RX/TX memory size register(RMSR & TMSR)
  _S3_SM        = %1100_0000    'Socket 3 size mask
  _S2_SM        = %0011_0000    'Socket 2 size mask
  _S1_SM        = %0000_1100    'Socket 1 size mask
  _S0_SM        = %0000_0011    'Socket 0 size mask

  _1KB          = %00           '1KB memory size
  _2KB          = %01           '2KB memory size
  _4KB          = %10           '4KB memory size
  _8KB          = %11           '8KB memory size

  'Used in the socket n mode register (Sn_MR)
  _MULTIM       = %1000_0000    'Enable/disable multicasting in UDP
  _PROTOCOLM    = %0000_1111    'Registers for setting protocol

  _CLOSEDPROTO  = %0000         'Closed
  _TCPPROTO     = %0001         'TCP
  _UDPPROTO     = %0010         'UDP
  _IPRAWPROTO   = %0011         'IPRAW
  _MACRAW       = %0100         'MACRAW (used in socket 0)
  _PPPOEPROTO   = %0101         'PPPoE (used in socket 0)

  'Used in the socket n command register (Sn_CR)
  _OPEN         = $01           'Initialize a socket
  _LISTEN       = $02           'In TCP mode, waits for request from client
  _CONNECT      = $04           'In TCP mode, sends connect request to server
  _DISCON       = $08           'In TCP mode, request to disconnect
  _CLOSE        = $10           'Closes socket
  _SEND         = $20           'Transmits data
  _SEND_MAC     = $21           'In UDP mode, like send, but uses MAC
  _SEND_KEEP    = $22           'In TCP mode, check connection status by sending 1 byte
  _RECV         = $40           'Receiving is processed

  'Used in socket n interrupt register (Sn_IR)
  _SEND_OKM     = %0001_0000    'Set to 1 if send operation is completed
  _TIMEOUTM     = %0000_1000    'Set to 1 if timeout occured during transmission
  _RECVM        = %0000_0100    'Set to 1 if data is received
  _DISCONM      = %0000_0010    'Set to 1 if connection termination is requested
  _CONM         = %0000_0001    'Set to 1 if connection is established

  'Used in socket n status register (Sn_SR)
  _SOCK_CLOSED  = $00
  _SOCK_INIT    = $13
  _SOCK_LISTEN  = $14
  _SOCK_SYNSENT = $15
  _SOCK_SYNRECV = $16
  _SOCK_ESTAB   = $17
  _SOCK_FIN_WAIT= $18
  _SOCK_CLOSING = $1A
  _SOCK_TIME_WAIT=$1B
  _SOCK_LACK_ACK =$1D
  _SOCK_CLOSE_WT= $1C
  _SOCK_UDP     = $22
  _SOCK_IPRAW   = $32
  _SOCK_MACRAW  = $42
  _SOCK_PPPOE   = $5F

  _SOCK_ARP1    = $11
  _SOCK_ARP2    = $21
  _SOCK_ARP3    = $31

  'SPI OP-code when assembly packet to read/write to W5100
  _WRITEOP      = $F0           'Signals a write operation in SPI mode
  _READOP       = $0F           'Signals a read operation in SPI mode

  'RX & TX definitions
  _TX_base      = $4000         'Base address of TX buffer
  _RX_base      = $6000         'Base address of RX buffer

  _TX_mask_1k   = $03FF         'Mask for default 1K buffer for each socket
  _RX_mask_1K   = $03FF         'Mask for default 1K buffer for each socket

  _TX_mask_2k   = $07FF         'Mask for default 2K buffer for each socket
  _RX_mask_2K   = $07FF         'Mask for default 2K buffer for each socket

  _TX_mask_4k   = $0FFF         'Mask for default 4K buffer for each socket
  _RX_mask_4K   = $0FFF         'Mask for default 4K buffer for each socket

  _TX_mask_8k   = $1FFF         'Mask for default 8K buffer for each socket
  _RX_mask_8K   = $1FFF         'Mask for default 8K buffer for each socket

  _UDP_header   = 8             '8 bytes of data in the UDP header from the W5100

PUB unused ' Has to be here to compile (in case it is a top-object)
