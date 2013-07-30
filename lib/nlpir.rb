# coding: utf-8
require File.expand_path("../nlpir/version", __FILE__)
require 'fiddle'
require 'fiddle/struct'
require 'fiddle/import'
require 'fileutils' 
include Fiddle::CParser
include Fiddle::Importer

module Nlpir
  NLPIR_FALSE = 0
  NLPIR_TRUE = 1
  POS_MAP_NUMBER = 4
  ICT_POS_MAP_FIRST = 1            #计算所一级标注集
  ICT_POS_MAP_SECOND = 0       #计算所二级标注集
  PKU_POS_MAP_SECOND = 2       #北大二级标注集
  PKU_POS_MAP_FIRST = 3	#北大一级标注集
  POS_SIZE = 40

  Result_t = struct ['int start','int length',"char  sPOS[#{POS_SIZE}]",'int iPOS',
  		          'int word_ID','int word_type','double weight']

  GBK_CODE = 0                                                    #默认支持GBK编码
  UTF8_CODE = GBK_CODE + 1                          #UTF8编码
  BIG5_CODE = GBK_CODE + 2                          #BIG5编码
  GBK_FANTI_CODE = GBK_CODE + 3             #GBK编码，里面包含繁体字


  #提取链接库接口
  libm = Fiddle.dlopen(File.expand_path("../../bin/NLPIR.dll", __FILE__))
 
 NLPIR_Init_rb = Fiddle::Function.new(
  libm['?NLPIR_Init@@YA_NPBDH@Z'],
  [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT],
  Fiddle::TYPE_INT
  )
NLPIR_Exit_rb = Fiddle::Function.new(
  libm['?NLPIR_Exit@@YA_NXZ'],
  [],
  Fiddle::TYPE_INT
  )
NLPIR_ImportUserDict_rb = Fiddle::Function.new(
  libm['?NLPIR_ImportUserDict@@YAIPBD@Z'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
  )
NLPIR_ParagraphProcess_rb = Fiddle::Function.new(
  libm['?NLPIR_ParagraphProcess@@YAPBDPBDH@Z'],
  [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT],
  Fiddle::TYPE_VOIDP
  )
NLPIR_ParagraphProcessA_rb = Fiddle::Function.new(
  libm['?NLPIR_ParagraphProcessA@@YAPBUresult_t@@PBDPAH_N@Z'],
  [Fiddle::TYPE_VOIDP,Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_VOIDP
  )
NLPIR_FileProcess_rb = Fiddle::Function.new(
  libm['?NLPIR_FileProcess@@YANPBD0H@Z'],
  [Fiddle::TYPE_VOIDP,Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT],
  Fiddle::TYPE_DOUBLE
  )
NLPIR_GetParagraphProcessAWordCount_rb = Fiddle::Function.new(
  libm['?NLPIR_GetParagraphProcessAWordCount@@YAHPBD@Z'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
  )
NLPIR_ParagraphProcessAW_rb = Fiddle::Function.new(
  libm['?NLPIR_ParagraphProcessAW@@YAXHPAUresult_t@@@Z'],
  [Fiddle::TYPE_INT,Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
  )
NLPIR_AddUserWord_rb = Fiddle::Function.new(
  libm['?NLPIR_AddUserWord@@YAHPBD@Z'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
  )
NLPIR_SaveTheUsrDic_rb = Fiddle::Function.new(
  libm['?NLPIR_SaveTheUsrDic@@YAHXZ'],
  [],
  Fiddle::TYPE_INT
  )
NLPIR_DelUsrWord_rb = Fiddle::Function.new(
  libm['?NLPIR_DelUsrWord@@YAHPBD@Z'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
  )
NLPIR_GetKeyWords_rb = Fiddle::Function.new(
    libm['?NLPIR_GetKeyWords@@YAPBDPBDH_N@Z'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
NLPIR_GetFileKeyWords_rb = Fiddle::Function.new(
    libm['?NLPIR_GetFileKeyWords@@YAPBDPBDH_N@Z'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
NLPIR_GetNewWords_rb = Fiddle::Function.new(
    libm['?NLPIR_GetNewWords@@YAPBDPBDH_N@Z'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
NLPIR_GetFileNewWords_rb = Fiddle::Function.new(
    libm['?NLPIR_GetFileNewWords@@YAPBDPBDH_N@Z'],
    [Fiddle::TYPE_VOIDP,Fiddle::TYPE_INT,Fiddle::TYPE_INT],
    Fiddle::TYPE_VOIDP
  )
NLPIR_FingerPrint_rb = Fiddle::Function.new(
    libm['?NLPIR_FingerPrint@@YAKPBD@Z'],
    [Fiddle::TYPE_VOIDP],
    Fiddle::TYPE_LONG
  )
NLPIR_SetPOSmap_rb = Fiddle::Function.new(
  libm['?NLPIR_SetPOSmap@@YAHH@Z'],
  [Fiddle::TYPE_INT],
  Fiddle::TYPE_INT
  )

NLPIR_NWI_Start_rb = Fiddle::Function.new(
  libm['?NLPIR_NWI_Start@@YA_NXZ'],
  [],
  Fiddle::TYPE_INT
  )
NLPIR_NWI_AddFile_rb = Fiddle::Function.new(
  libm['?NLPIR_NWI_AddFile@@YAHPBD@Z'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
  )
 NLPIR_NWI_AddMem_rb = Fiddle::Function.new(
  libm['?NLPIR_NWI_AddMem@@YA_NPBD@Z'],
  [Fiddle::TYPE_VOIDP],
  Fiddle::TYPE_INT
  )
 NLPIR_NWI_Complete_rb = Fiddle::Function.new(
  libm['?NLPIR_NWI_Complete@@YA_NXZ'],
  [],
  Fiddle::TYPE_INT
  )
 NLPIR_NWI_GetResult_rb = Fiddle::Function.new(
  libm['?NLPIR_NWI_GetResult@@YAPBD_N@Z'],
  [Fiddle::TYPE_INT],
  Fiddle::TYPE_VOIDP
  )
  NLPIR_NWI_Result2UserDict_rb = Fiddle::Function.new(
  libm['?NLPIR_NWI_Result2UserDict@@YAIXZ'],
  [],
  Fiddle::TYPE_VOIDP
  )

  #--函数

  def NLPIR_Init(sInitDirPath=nil , encoding=UTF8_CODE, filepath)
    filepath += "/Data/"
    if File.exist?(filepath)==false
      FileUtils.mkdir(filepath)
      filemother = File.expand_path("../Data/", __FILE__)
      list=Dir.entries(filemother)
      list.each_index do |x| 
        t = filemother+"/"+list[x]
        FileUtils.cp(t,filepath) if !File.directory?(t) 
      end
    end
    
    
    NLPIR_Init_rb.call(sInitDirPath,encoding)

  end

  def NLPIR_Exit()
    i = NLPIR_Exit_rb.call()
    return NLPIR_TRUE if i > 0 
  end

  def NLPIR_ImportUserDict(sFilename)
    NLPIR_ImportUserDict_rb.call(sFilename)
  end

  def NLPIR_ParagraphProcess(sParagraph, bPOStagged=NLPIR_TRUE)
    NLPIR_ParagraphProcess_rb.call(sParagraph, bPOStagged).to_s
  end

  def NLPIR_ParagraphProcessA(sParagraph)
    resultCount = NLPIR_GetParagraphProcessAWordCount(sParagraph)
    pResultCount = Fiddle::Pointer.to_ptr(resultCount)
    p = NLPIR_ParagraphProcessA_rb.call(sParagraph, pResultCount.ref.to_i)
    pVecResult = Fiddle::Pointer.new(p.to_i)
    words_list = []
    words_list << Result_t.new(pVecResult)
    for i in 1...resultCount  do
        words_list << Result_t.new(pVecResult += Result_t.size)
    end
    return words_list
  end

    def NLPIR_FileProcess(sSourceFilename, sResultFilename, bPOStagged=NLPIR_TRUE)
      NLPIR_FileProcess_rb.call(sSourceFilename, sResultFilename, bPOStagged)
    end

    def NLPIR_GetParagraphProcessAWordCount(sParagraph)
      NLPIR_GetParagraphProcessAWordCount_rb.call(sParagraph)
    end

    def NLPIR_ParagraphProcessAW(sParagraph)
      free = Fiddle::Function.new(Fiddle::RUBY_FREE, [TYPE_VOIDP], TYPE_VOID)
      resultCount = NLPIR_GetParagraphProcessAWordCount(sParagraph)
      pVecResult = Pointer.malloc(Result_t.size*resultCount,free)
      NLPIR_ParagraphProcessAW_rb.call(resultCount,pVecResult)
      words_list = []
      words_list << Result_t.new(pVecResult)
      for i in 1...resultCount do
          words_list << Result_t.new(pVecResult+=Result_t.size)
      end
      return words_list
    end

    def NLPIR_AddUserWord(sWord)
      NLPIR_AddUserWord_rb.call(sWord)
    end

    def NLPIR_SaveTheUsrDic()
      NLPIR_SaveTheUsrDic_rb.call()
    end

    def NLPIR_DelUsrWord(sWord)
      NLPIR_DelUsrWord_rb.call(sWord)
    end

    def NLPIR_GetKeyWords(sLine, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
      NLPIR_GetKeyWords_rb.call(sLine, nMaxKeyLimit, bWeightOut).to_s
    end

    def NLPIR_GetFileKeyWords(sTextFile, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
      NLPIR_GetFileKeyWords_rb.call(sTextFile, nMaxKeyLimit, bWeightOut).to_s
    end

    def NLPIR_GetNewWords(sLine, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
      NLPIR_GetNewWords_rb.call(sLine, nMaxKeyLimit, bWeightOut).to_s
    end

    def NLPIR_GetFileNewWords(sTextFile, nMaxKeyLimit=50, bWeightOut=NLPIR_FALSE)
      NLPIR_GetFileNewWords_rb.call(sTextFile, nMaxKeyLimit, bWeightOut).to_s
    end

    def NLPIR_FingerPrint(sLine)
      NLPIR_FingerPrint_rb.call(sLine)
    end

    def NLPIR_SetPOSmap(nPOSmap)
      NLPIR_SetPOSmap_rb.call(nPOSmap)
    end

    def NLPIR_NWI_Start()
      NLPIR_NWI_Start_rb.call()
    end

    def NLPIR_NWI_AddFile(sFilename)
      NLPIR_NWI_AddFile_rb.call(sFilename)
    end

    def NLPIR_NWI_AddMem(sFilename)
      NLPIR_NWI_AddMem_rb.call(sFilename)
    end

    def NLPIR_NWI_Complete()
      NLPIR_NWI_Complete_rb.call()
    end

    def NLPIR_NWI_GetResult( bWeightOut = NLPIR_FALSE)
      NLPIR_NWI_GetResult_rb.call(bWeightOut)
    end

    def NLPIR_NWI_Result2UserDict()
      NLPIR_NWI_Result2UserDict_rb.call()
    end

  end
