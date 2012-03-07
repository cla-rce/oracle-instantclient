#
# Cookbook Name:: cla_unix_baseline
# Recipe:: compute_packages
#
# Copyright 2011, Joshua Buysse, (C) Regents of the University of Minnesota
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ubuntu_lucid_plist = %w( ia32-libs libsm-dev libglu-mesa1-dev libxext-dev libxmu-dev libxt-dev sun-java6-jdk
sun-java6-fonts sun-java6-demo dbus-x11 defoma-doc binfmt-support ttf-unfonts ttf-unfonts-core libmyodbc tdsodbc
unixodbc-dev unixodbc-bin x-ttcidfont-conf sun-java6-source ghostscript-x mesa-utils libpng3 libtiff4 libmotif3
libexpat1 lsof a2ps abicheck axiom axiom-doc axiom-graphics axiom-databases axiom-graphics-data axiom-tex
axiom-hypertex axiom-hypertex-data bcrypt bc bioperl bioperl-run biosquid-dev biosquid blast2 cadabra cflow ctioga
ctsim ctsim-doc ctsim-help dcmtk dcmtk-doc dc dicom3tools dicomnifti dicomscope dx dx-doc epix exrtools extrema
extrema-doc fenics freeglut3 freemat freemat-data freemat-help gambit gambit-doc gap gnudatalanguage graphicsmagick
grap grass grass-dev grass-doc gri gsfonts gsfonts-other gsfonts-x11 gv ifrit imagemagick last-align mathomatic matita
matita-doc maxima maxima-doc maxima-emacs maxima-share mdbtools mdbtools-gmdb minlog mitools nifti-bin octave3.2
octave3.2-doc otter pari-gp pari-extra pari-doc poa psychopy python-biopython-doc python-biopython python-genetic
python-imaging python-imaging-tk python-imaging-doc python-nifti python-numeric python-numeric-ext python-numpy
python-numpy-ext python-scientific python-scientific-doc python-scitools python-scipy r-base r-base-html r-base-dev
r-base-core r-doc-html r-doc-pdf r-mathlib r-recommended samtools seaview slicer slicer-data texlive-full
texlive-lang-all texpower tkdiff tkinfo tkman ttf-freefont mathematica-fonts tulip tulip-doc ugene-data ugene velvet
velvet-example wise wise-doc xaw3dg xfig xfig-libs transfig xgrep xmaxima xmldiff xpdf firefox libgdome2-0
libgdome2-dev libdcmtk1-dev libnetcdf-dev libxslt-dev medcon xmedcon 
libgtksourceview1.0-0 )

## this is not complete, relying on kickstart right now for this to work.
rh_5_plist = %w( gtksourceview )

case node[:platform]
when "ubuntu"
  ubuntu_lucid_plist.each do |pkg|
    package pkg
  end
when "redhat", "centos" 
  rh_5_plist.each do |pkg|
    package pkg
  end
end

include_recipe "cla_unix_baseline::bliss_old_libs"
