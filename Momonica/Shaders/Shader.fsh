//
//  Shader.fsh
//  Momonica
//
//  Created by Azim Pradhan on 2/6/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
