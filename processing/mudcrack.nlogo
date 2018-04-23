;;
;; mudcrack.nlogo, Copyright (c) 2005 by Roger E Critchlow Jr, Santa Fe, New Mexico, USA
;; This program is free software, licensed under the terms of the Gnu Public License.
;;
;; See Nature, 426: 271-274, November 20, 2003 for details
;;

globals [
  ;; coverage	     ;; cell fraction of particles, slider
  ;; eps-ll		     ;; strength of liquid-liquid attraction, slider
  ;; eps-nn      	 ;; strength of particle-particle attraction, slider
  ;; eps-nl      	 ;; strength of particle-liquid attraction, slider
  ;; mu            ;; chemical potential of liquid-vapor transition, slider
  ;; pmovement     ;; probability of diffusion step given particle patch, slider
  clock		         ;; count the iterations
  particle-color
  liquid-color
  vapor-color
  report-velocity
  velocity
  nsamples
]

patches-own [
  liquid
  particle
  nliquid
  nparticle
]

to setup
  ca
  set clock 0
  set particle-color brown + 2.5
  set liquid-color yellow - 1
  set vapor-color brown - 1
  set report-velocity true
  set velocity 0
  set nsamples 0
  ask patches [
    ifelse (random-float 1.0) < coverage [ make-particle ] [ make-liquid ]
  ]
end 

to go
  let chunk 100000
  reset-timer
  repeat chunk [
    set clock clock + 1
    ask random-one-of patches [
      ifelse is-particle? [
        if (random-float 1.0) < pmovement [ try-moving-particle ]
      ] [
        ifelse is-liquid? [ try-evaporate-liquid ] [ try-condense-vapor ]
      ]
    ]
  ]
  if report-velocity [
    set velocity (nsamples * velocity + (chunk / timer)) / (nsamples + 1)
    set nsamples nsamples + 1
    show (word (round velocity) " steps/second over " nsamples " samples")
  ]
end

to default
  set coverage 0.40
  set eps-ll 2.00
  set eps-nl 3.00
  set eps-nn 4.00
  set mu -4.50
  set pmovement 0.1
end

to sum-neighbors
  set nliquid sum values-from neighbors4 [ liquid ]
  set nparticle sum values-from neighbors4 [ particle ]
end
  
to try-moving-particle
  locals [dir]
  ;; pick a random direction
  set dir random-one-of neighbors4
  ;; see if there's liquid in that direction
  if value-from dir [ is-liquid? ] [
    sum-neighbors
    ask dir [ sum-neighbors ]
    if accept energy-of-motion dir [
      make-liquid
      ask dir [ make-particle ]
    ]
  ]
end

to try-evaporate-liquid
  sum-neighbors
  if accept energy-of-evaporation [ make-vapor ]
end

to try-condense-vapor
  sum-neighbors
  if accept energy-of-condensation [ make-liquid ]
end

to-report accept [deltaH]
  ;; compute the acceptance criterion
  report (random-float 1.0) < min (list 1 exp (- deltaH))  
end

to-report energy-as-vapor
  report 0
end

to-report energy-as-liquid
  report (- eps-ll * nliquid) - (eps-nl * nparticle) - mu
end

to-report energy-as-particle
  report (- eps-nn * nparticle) - (eps-nl * nliquid)
end

to-report energy-as-liquid-moving
  ;; this cell is a particle trying to move into an adjacent liquid cell,
  ;; so when we evaluate the energy as a liquid we assume that one of 
  ;; the neighboring liquid cells has become a particle,
  ;; hence nliquid is 1 too big, and nparticle is 1 too small
  report (- eps-ll * (nliquid - 1)) - (eps-nl * (nparticle + 1)) - mu
end

to-report energy-as-particle-moving
  ;; this cell is a liquid trying to be displaced by a particle
  ;; hence nliquid is 1 too small and nparticle is 1 too big
  report (- eps-nn * (nparticle - 1)) - (eps-nl * (nliquid + 1))
end

to-report energy-of-evaporation
  report energy-as-vapor - energy-as-vapor
end

to-report energy-of-condensation
  report energy-as-liquid - energy-as-vapor
end

to-report energy-of-motion [dir]
  report ((energy-as-liquid-moving - energy-as-particle)
             + (value-from dir [ energy-as-particle-moving - energy-as-liquid ]))
end

to make-liquid
  set liquid 1
  set particle 0
  set pcolor liquid-color
end

to-report is-liquid?
  report liquid = 1
end

to make-vapor
  set liquid 0
  set particle 0
  set pcolor vapor-color
end

to-report is-vapor?
  report (liquid = 0) and (particle = 0)
end

to make-particle 
  set liquid 0
  set particle 1
  set pcolor particle-color
end

to-report is-particle?
  report particle = 1
end
@#$#@#$#@
GRAPHICS-WINDOW
331
10
1143
843
200
200
2.0
0
10
1
1
1
0
1
1
1

CC-WINDOW
5
857
1152
952
Command Center
0

BUTTON
27
10
96
43
NIL
setup
NIL
1
T
OBSERVER
T
NIL

BUTTON
108
10
171
43
NIL
go
T
1
T
OBSERVER
T
NIL

SLIDER
27
49
298
82
coverage
coverage
0
1
0.4
0.0010
1
NIL

SLIDER
27
85
300
118
eps-ll
eps-ll
-16
16
2.0
0.01
1
kT

SLIDER
27
154
301
187
eps-nn
eps-nn
2
8
4.0
0.01
1
kT

SLIDER
27
119
301
152
eps-nl
eps-nl
2
8
3.0
0.01
1
kT

SLIDER
27
191
302
224
mu
mu
-16
16
-4.5
0.05
1
kT

SLIDER
27
228
302
261
pmovement
pmovement
0
1
0.1
0.0010
1
NIL

BUTTON
183
11
253
44
NIL
default
NIL
1
T
OBSERVER
T
NIL

@#$#@#$#@
WHAT IS IT?
-----------
This model illustrates the article "Drying-mediated self-assembly of nanoparticles" from Nature, 246, 271-274, 20 November 2003.  There is pattern formation in crystallization of nanoparticles under irreversible drying.  

HOW IT WORKS
------------
The model defines a grid of lattice points which may be occupied by liquid, vapor, or nanoparticle.  There is an energy associated with contacts between liquid occupied cells (eps-l), with contacts between solid occupied cells (eps-n), with contacts between solid and liquid occupied cells (eps-nl) and with liquid-vapor transitions (mu).

We compute the energy of a configuration surrounding a lattice point i by a formula involving sums over the four adjacent neighbors of i, lattice points j.  The formula has a term for liquid-liquid contacts, - eps-l sum(liquid(i) liquid(j)), a term for solid-solid contacts, - eps-n sum(particle(i) particle(j)), a term for solid-liquid contacts,  - eps-nl sum(particle(i) liquid(j), and a term for evaporation, - mu liquid(i).  

(Note that there is no term for a liquid center adjacent to a solid, - eps-nl sum(liquid(i) solid(j).  I don't know why it is missing, it seems it should contribute to the energy of the configuration.)

The simulation involves simulation of liquid-vapor transition and of particle diffusion.  The phase transition simply converts the  Each of these is simulated by computing a delta H for the phase transition or the particle diffusion step and accepting the 
;
; the simulation takes place on a square lattice, (i).
; each lattice cell may be occupied by solvent or vapor, l(i) = 1 or 0.
; adjacent solvent cells attract each other with strength eps(l).
; the chemical potential, mu, and temperature, T, of the surrounding
; vapor bath determine the equilibrium concentration of liquid and vapor.
; a lattice cell occupied by vapor may also be occupied by nanoparticle,
; n(i) = 1 or 0.
;
; nanoparticles are attracted to liquid with strength eps(nl) and to each
; other with strength eps(n) and form aggregates in the absence of liquid
; which may span several cells.
;
; The nanoparticles are 4x4 grid units in size.  
; eps(n) = 2eps(l).
; eps(nl) = 1.5
; 
; the dynamics of the model is stochastic: attempt to convert a randomly
; chosen cell, i, from liquid to vapor or vice versa, the perturbation accepted
; with Metropolis probability p(acc) = min(1, exp(-delta(H)/(K(b)T))), the
; delta(H) = -eps(l)sum(l(i)l(j)) - eps(n)sum(n(i)n(j)) -eps(nl)sum(n(i)l(j) - mu l(i)
;
; now I'm confused, I guess the delta(H) applies to the changed part of the
; configuration, because we're going to use the same p(acc) for the movement
; of nanoparticles, too.
;
; the lattice is three state: liquid, vapor, or nanoparticle.
;
; the dynamics has a liquid<->vapor transition, and a particle movement
; transition, depending on the state of the randomly chosen cell.
;
; the initial condition is the coverage of nanoparticles,  sum(n(i))/sum(i).
; 
; Figure 2. coverages of 5%, 30%, 40% and 60%, K(b)T = eps(l)/2, mu = -2.25eps(l),
; Figure 4. coverages of 10%, 20%, and 30%, K(b)T = eps(l)/4,



HOW TO USE IT
-------------
The first thing to try is to let liquid evaporate and see how eps-l and mu trade-off to determine the equilibrium vapor pressure.  Set the coverage to 0%, so there will be no nanoparticles at all, setup, and go.  As you increase eps-l, making liquid-liquid contact more favorable, or decrease mu, making the liquid state more favorable, the equilibrium vapor pressure will decrease as.


THINGS TO NOTICE
----------------
This section could give some ideas of things for the user to notice while running the model.


THINGS TO TRY
-------------
This section could give some ideas of things for the user to try to do (move sliders, switches, etc.) with the model.


EXTENDING THE MODEL
-------------------
This section could give some ideas of things to add or change in the procedures tab to make the model more complicated, detailed, accurate, etc.


NETLOGO FEATURES
----------------
This section could point out any especially interesting or unusual features of NetLogo that the model makes use of, particularly in the Procedures tab.  It might also point out places where workarounds were needed because of missing features.


RELATED MODELS
--------------
This section could give the names of models in the NetLogo Models Library or elsewhere which are of related interest.


CREDITS AND REFERENCES
----------------------
This section could contain a reference to the model's URL on the web if it has one, as well as any other necessary credits or references.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bee
true
0
Polygon -1184463 true false 152 149 77 163 67 195 67 211 74 234 85 252 100 264 116 276 134 286 151 300 167 285 182 278 206 260 220 242 226 218 226 195 222 166
Polygon -16777216 true false 150 149 128 151 114 151 98 145 80 122 80 103 81 83 95 67 117 58 141 54 151 53 177 55 195 66 207 82 211 94 211 116 204 139 189 149 171 152
Polygon -7500403 true true 151 54 119 59 96 60 81 50 78 39 87 25 103 18 115 23 121 13 150 1 180 14 189 23 197 17 210 19 222 30 222 44 212 57 192 58
Polygon -16777216 true false 70 185 74 171 223 172 224 186
Polygon -16777216 true false 67 211 71 226 224 226 225 211 67 211
Polygon -16777216 true false 91 257 106 269 195 269 211 255
Line -1 false 144 100 70 87
Line -1 false 70 87 45 87
Line -1 false 45 86 26 97
Line -1 false 26 96 22 115
Line -1 false 22 115 25 130
Line -1 false 26 131 37 141
Line -1 false 37 141 55 144
Line -1 false 55 143 143 101
Line -1 false 141 100 227 138
Line -1 false 227 138 241 137
Line -1 false 241 137 249 129
Line -1 false 249 129 254 110
Line -1 false 253 108 248 97
Line -1 false 249 95 235 82
Line -1 false 235 82 144 100

bird1
false
0
Polygon -7500403 true true 2 6 2 39 270 298 297 298 299 271 187 160 279 75 276 22 100 67 31 0

bird2
false
0
Polygon -7500403 true true 2 4 33 4 298 270 298 298 272 298 155 184 117 289 61 295 61 105 0 43

boat1
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

boat2
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 157 54 175 79 174 96 185 102 178 112 194 124 196 131 190 139 192 146 211 151 216 154 157 154
Polygon -7500403 true true 150 74 146 91 139 99 143 114 141 123 137 126 131 129 132 139 142 136 126 142 119 147 148 147

boat3
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 37 172 45 188 59 202 79 217 109 220 130 218 147 204 156 158 156 161 142 170 123 170 102 169 88 165 62
Polygon -7500403 true true 149 66 142 78 139 96 141 111 146 139 148 147 110 147 113 131 118 106 126 71

box
true
0
Polygon -7500403 true true 45 255 255 255 255 45 45 45

butterfly1
true
0
Polygon -16777216 true false 151 76 138 91 138 284 150 296 162 286 162 91
Polygon -7500403 true true 164 106 184 79 205 61 236 48 259 53 279 86 287 119 289 158 278 177 256 182 164 181
Polygon -7500403 true true 136 110 119 82 110 71 85 61 59 48 36 56 17 88 6 115 2 147 15 178 134 178
Polygon -7500403 true true 46 181 28 227 50 255 77 273 112 283 135 274 135 180
Polygon -7500403 true true 165 185 254 184 272 224 255 251 236 267 191 283 164 276
Line -7500403 true 167 47 159 82
Line -7500403 true 136 47 145 81
Circle -7500403 true true 165 45 8
Circle -7500403 true true 134 45 6
Circle -7500403 true true 133 44 7
Circle -7500403 true true 133 43 8

circle
false
0
Circle -7500403 true true 35 35 230

person
false
0
Circle -7500403 true true 155 20 63
Rectangle -7500403 true true 158 79 217 164
Polygon -7500403 true true 158 81 110 129 131 143 158 109 165 110
Polygon -7500403 true true 216 83 267 123 248 143 215 107
Polygon -7500403 true true 167 163 145 234 183 234 183 163
Polygon -7500403 true true 195 163 195 233 227 233 206 159

sheep
false
15
Rectangle -1 true true 90 75 270 225
Circle -1 true true 15 75 150
Rectangle -16777216 true false 81 225 134 286
Rectangle -16777216 true false 180 225 238 285
Circle -16777216 true false 1 88 92

spacecraft
true
0
Polygon -7500403 true true 150 0 180 135 255 255 225 240 150 180 75 240 45 255 120 135

square4x4
false
3
Rectangle -6459832 true true 121 121 179 181

thin-arrow
true
0
Polygon -7500403 true true 150 0 0 150 120 150 120 293 180 293 180 150 300 150

truck-down
false
0
Polygon -7500403 true true 225 30 225 270 120 270 105 210 60 180 45 30 105 60 105 30
Polygon -8630108 true false 195 75 195 120 240 120 240 75
Polygon -8630108 true false 195 225 195 180 240 180 240 225

truck-left
false
0
Polygon -7500403 true true 120 135 225 135 225 210 75 210 75 165 105 165
Polygon -8630108 true false 90 210 105 225 120 210
Polygon -8630108 true false 180 210 195 225 210 210

truck-right
false
0
Polygon -7500403 true true 180 135 75 135 75 210 225 210 225 165 195 165
Polygon -8630108 true false 210 210 195 225 180 210
Polygon -8630108 true false 120 210 105 225 90 210

turtle
true
0
Polygon -7500403 true true 138 75 162 75 165 105 225 105 225 142 195 135 195 187 225 195 225 225 195 217 195 202 105 202 105 217 75 225 75 195 105 187 105 135 75 142 75 105 135 105

wolf
false
0
Rectangle -7500403 true true 15 105 105 165
Rectangle -7500403 true true 45 90 105 105
Polygon -7500403 true true 60 90 83 44 104 90
Polygon -16777216 true false 67 90 82 59 97 89
Rectangle -1 true false 48 93 59 105
Rectangle -16777216 true false 51 96 55 101
Rectangle -16777216 true false 0 121 15 135
Rectangle -16777216 true false 15 136 60 151
Polygon -1 true false 15 136 23 149 31 136
Polygon -1 true false 30 151 37 136 43 151
Rectangle -7500403 true true 105 120 263 195
Rectangle -7500403 true true 108 195 259 201
Rectangle -7500403 true true 114 201 252 210
Rectangle -7500403 true true 120 210 243 214
Rectangle -7500403 true true 115 114 255 120
Rectangle -7500403 true true 128 108 248 114
Rectangle -7500403 true true 150 105 225 108
Rectangle -7500403 true true 132 214 155 270
Rectangle -7500403 true true 110 260 132 270
Rectangle -7500403 true true 210 214 232 270
Rectangle -7500403 true true 189 260 210 270
Line -7500403 true 263 127 281 155
Line -7500403 true 281 155 281 192

wolf-left
false
3
Polygon -6459832 true true 117 97 91 74 66 74 60 85 36 85 38 92 44 97 62 97 81 117 84 134 92 147 109 152 136 144 174 144 174 103 143 103 134 97
Polygon -6459832 true true 87 80 79 55 76 79
Polygon -6459832 true true 81 75 70 58 73 82
Polygon -6459832 true true 99 131 76 152 76 163 96 182 104 182 109 173 102 167 99 173 87 159 104 140
Polygon -6459832 true true 107 138 107 186 98 190 99 196 112 196 115 190
Polygon -6459832 true true 116 140 114 189 105 137
Rectangle -6459832 true true 109 150 114 192
Rectangle -6459832 true true 111 143 116 191
Polygon -6459832 true true 168 106 184 98 205 98 218 115 218 137 186 164 196 176 195 194 178 195 178 183 188 183 169 164 173 144
Polygon -6459832 true true 207 140 200 163 206 175 207 192 193 189 192 177 198 176 185 150
Polygon -6459832 true true 214 134 203 168 192 148
Polygon -6459832 true true 204 151 203 176 193 148
Polygon -6459832 true true 207 103 221 98 236 101 243 115 243 128 256 142 239 143 233 133 225 115 214 114

wolf-right
false
3
Polygon -6459832 true true 170 127 200 93 231 93 237 103 262 103 261 113 253 119 231 119 215 143 213 160 208 173 189 187 169 190 154 190 126 180 106 171 72 171 73 126 122 126 144 123 159 123
Polygon -6459832 true true 201 99 214 69 215 99
Polygon -6459832 true true 207 98 223 71 220 101
Polygon -6459832 true true 184 172 189 234 203 238 203 246 187 247 180 239 171 180
Polygon -6459832 true true 197 174 204 220 218 224 219 234 201 232 195 225 179 179
Polygon -6459832 true true 78 167 95 187 95 208 79 220 92 234 98 235 100 249 81 246 76 241 61 212 65 195 52 170 45 150 44 128 55 121 69 121 81 135
Polygon -6459832 true true 48 143 58 141
Polygon -6459832 true true 46 136 68 137
Polygon -6459832 true true 45 129 35 142 37 159 53 192 47 210 62 238 80 237
Line -16777216 false 74 237 59 213
Line -16777216 false 59 213 59 212
Line -16777216 false 58 211 67 192
Polygon -6459832 true true 38 138 66 149
Polygon -6459832 true true 46 128 33 120 21 118 11 123 3 138 5 160 13 178 9 192 0 199 20 196 25 179 24 161 25 148 45 140
Polygon -6459832 true true 67 122 96 126 63 144

@#$#@#$#@
NetLogo 3.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
