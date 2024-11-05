#CPUFeatureDetect.cmake

include(CheckCXXCompilerFlag)
macro(genCPUFeatures TARGET)

    check_cxx_compiler_flag("-mfpu=neon" COMPILER_SUPPORTS_NEON)
    if(COMPILER_SUPPORTS_NEON)
        set(${TARGET}_FEATURE_NEON TRUE)
    else(COMPILER_SUPPORTS_NEON)
        set(${TARGET}_FEATURE_NEON FALSE)
    endif()
endmacro()