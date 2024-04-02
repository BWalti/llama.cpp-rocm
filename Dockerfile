ARG ROCM_VERSION=6.0

FROM rocm/dev-ubuntu-22.04:${ROCM_VERSION}-complete AS build

WORKDIR /app

RUN git clone https://github.com/ggerganov/llama.cpp.git .

RUN make LLAMA_HIPBLAS=1
RUN CMAKE_ARGS="-D LLAMA_HIPBLAS=ON -D CMAKE_C_COMPILER=/opt/rocm/bin/amdclang -D CMAKE_CXX_COMPILER=/opt/rocm/bin/amdclang++ -D CMAKE_PREFIX_PATH=/opt/rocm -D AMDGPU_TARGETS=gfx1100" \
    FORCE_CMAKE=1 pip install llama-cpp-python --upgrade --force-reinstall --no-cache-dir

RUN pip install uvicorn anyio starlette fastapi sse_starlette starlette_context pydantic_settings transformers

ENV PATH="/app:$PATH"
CMD [ "main" ]