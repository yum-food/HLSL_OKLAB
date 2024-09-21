/*
 * MIT License
 *
 * Copyright (c) 2023-2024 yum_food
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
      0.0193, 0.1192, 0.9505);
  return saturate(mul(rgb_to_xyz, c));
}

// Weights: https://en.wikipedia.org/wiki/SRGB
float3 XYZtoLRGB(float3 c) {
  float3x3 xyz_to_rgb = float3x3(
      3.24062548, -1.53720797, -0.4986286,
      -0.96893071,  1.87575606,  0.04151752,
      0.05571012, -0.20402105,  1.05699594);
  return saturate(mul(xyz_to_rgb, c));
}

// Source: https://bottosson.github.io/posts/oklab/
float3 XYZtoOKLAB(float3 c) {
  float3x3 m1 = float3x3(
      0.8189330101, 0.3618667424, -0.1288597137,
      0.0329845436, 0.9293118715, 0.0361456387,
      0.0482003018, 0.2643662691, 0.6338517070);
  float3x3 m2 = float3x3(
      0.2104542553, 0.7936177850, -0.0040720468,
      1.9779984951, -2.4285922050, 0.4505937099,
      0.0259040371, 0.7827717662, -0.8086757660);
  c = mul(m1, c);
  c = pow(c, 0.33333333333);
  return mul(m2, c);
}

// Source: https://bottosson.github.io/posts/oklab/
float3 OKLABtoXYZ(float3 c) {
  float3x3 m1i = float3x3(
       1.22701385, -0.55779998,  0.28125615,
      -0.04058018,  1.11225687, -0.07167668,
      -0.07638128, -0.42148198,  1.58616322);
  float3x3 m2i = float3x3(
      1.00000000,  0.39633779,  0.21580376,
      1.00000001, -0.10556134, -0.06385417,
      1.00000005, -0.08948418, -1.29148554);
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

