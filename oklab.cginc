/*
 * MIT License
 *
 * Copyright (c) 2023 yum_food
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE
 * SOFTWARE.
 */

#ifndef __OKLAB_INC
#define __OKLAB_INC

// Utilities relating to the OKLAB color space, as defined here:
//   https://bottosson.github.io/posts/oklab/
// Code is derived from the samples there, which are in the public domain.

// Weights: https://en.wikipedia.org/wiki/SRGB
float3 LRGBtoXYZ(float3 c) {
  float3x3 rgb_to_xyz = float3x3(
      0.4124, 0.3576, 0.1805,
      0.2126, 0.7152, 0.0722,
      0.0193, 0.1192, 0.9505
      );
  return mul(rgb_to_xyz, c);
}

// Weights: https://en.wikipedia.org/wiki/SRGB
float3 XYZtoLRGB(float3 c) {
  float3x3 xyz_to_rgb = float3x3(
      3.24062548, -1.53720797, -0.4986286,
      -0.96893071,  1.87575606,  0.04151752,
      0.05571012, -0.20402105,  1.05699594
      );
  return mul(xyz_to_rgb, c);
}

// Source: https://bottosson.github.io/posts/oklab/
float3 XYZtoOKLAB(float3 c) {
  float3x3 m1 = float3x3(
      0.8189, 0.3618, -0.1288,
      0.0329, 0.9293, 0.0361,
      0.0482, 0.2643, 0.6338
      );
  float3x3 m2 = float3x3(
      0.2104, 0.7936, -0.0040,
      1.9779, -2.4285, 0.4505,
      0.0259, 0.7827, -0.8086
      );
  c = mul(m1, c);
  c = pow(c, 0.33333333333);
  return mul(m2, c);
}

// Source: https://bottosson.github.io/posts/oklab/
float3 OKLABtoXYZ(float3 c) {
  float3x3 m1i = float3x3(
      1.22700842, -0.5576564 ,  0.28111404,
      -0.04047048,  1.11219073, -0.07157255,
      -0.07643651, -0.42138367,  1.58625265
      );
  float3x3 m2i = float3x3(
      1.00003964,  0.39638005,  0.21589049,
      0.99998945, -0.10553958, -0.06374665,
      0.99999105, -0.08946276, -1.291495
      );
  c = mul(m2i, c);
  c = pow(c, 3);
  return mul(m1i, c);
}

// Source: https://bottosson.github.io/posts/oklab/
float3 OKLABtoOKLCH(float3 c) {
  float c_ = length(c.yz);
  float h_ = atan2(c.z, c.y);
  return float3(c.x, c_, h_);
}

// Source: https://bottosson.github.io/posts/oklab/
// Note: hue must be in units of radians.
float3 OKLCHtoOKLAB(float3 c) {
  float a = c.y * cos(c.z);
  float b = c.y * sin(c.z);
  return float3(c.x, a, b);
}

float3 LRGBtoOKLAB(float3 c) {
  return XYZtoOKLAB(LRGBtoXYZ(c));
}

float3 OKLABtoLRGB(float3 c) {
  return XYZtoLRGB(OKLABtoXYZ(c));
}

float3 LRGBtoOKLCH(float3 c) {
  return OKLABtoOKLCH(XYZtoOKLAB(LRGBtoXYZ(c)));
}

float3 OKLCHtoLRGB(float3 c) {
  return XYZtoLRGB(OKLABtoXYZ(OKLCHtoOKLAB(c)));
}

#endif  // __OKLAB_INC

