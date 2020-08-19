FROM gitpod/workspace-full

USER gitpod

RUN brew install R

RUN ssh richardu@134.249.146.45
