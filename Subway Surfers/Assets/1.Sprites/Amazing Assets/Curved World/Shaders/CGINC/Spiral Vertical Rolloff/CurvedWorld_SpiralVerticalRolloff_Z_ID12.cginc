#ifndef CURVEDWORLD_SPIRALVERTICALROLLOFF_Z_ID12_CGINC
#define CURVEDWORLD_SPIRALVERTICALROLLOFF_Z_ID12_CGINC

uniform float3 CurvedWorld_SpiralVerticalRolloff_Z_ID12_PivotPoint;
uniform float3 CurvedWorld_SpiralVerticalRolloff_Z_ID12_RotationCenter;
uniform float CurvedWorld_SpiralVerticalRolloff_Z_ID12_BendAngle;
uniform float CurvedWorld_SpiralVerticalRolloff_Z_ID12_BendMinimumRadius;
uniform float CurvedWorld_SpiralVerticalRolloff_Z_ID12_BendRolloff;

                 
#include "../../Core/Core.cginc"                           
             
      
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                Main Method                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_SpiralVerticalRolloff_Z_ID12(inout float4 vertexOS)
{
    CurvedWorld_SpiralVerticalRolloff_Z(vertexOS, 
							CurvedWorld_SpiralVerticalRolloff_Z_ID12_PivotPoint,
	                        CurvedWorld_SpiralVerticalRolloff_Z_ID12_RotationCenter,                            
							CurvedWorld_SpiralVerticalRolloff_Z_ID12_BendAngle,
							CurvedWorld_SpiralVerticalRolloff_Z_ID12_BendMinimumRadius,
							CurvedWorld_SpiralVerticalRolloff_Z_ID12_BendRolloff);
}

void CurvedWorld_SpiralVerticalRolloff_Z_ID12(inout float4 vertexOS, inout float3 normalOS, float4 tangent)
{
    CurvedWorld_SpiralVerticalRolloff_Z(vertexOS, 
                            normalOS, 
                            tangent,
							CurvedWorld_SpiralVerticalRolloff_Z_ID12_PivotPoint,
                            CurvedWorld_SpiralVerticalRolloff_Z_ID12_RotationCenter,                            
							CurvedWorld_SpiralVerticalRolloff_Z_ID12_BendAngle,
							CurvedWorld_SpiralVerticalRolloff_Z_ID12_BendMinimumRadius,
							CurvedWorld_SpiralVerticalRolloff_Z_ID12_BendRolloff);
}

void CurvedWorld_SpiralVerticalRolloff_Z_ID12(inout float3 vertexOS)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_SpiralVerticalRolloff_Z_ID12(vertex);

    vertexOS.xyz = vertex.xyz;
}

void CurvedWorld_SpiralVerticalRolloff_Z_ID12(inout float3 vertexOS, inout float3 normalOS, float4 tangent)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_SpiralVerticalRolloff_Z_ID12(vertex, normalOS, tangent);

    vertexOS.xyz = vertex.xyz;
} 

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                               SubGraph Methods                             //
//                                                                            // 
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_SpiralVerticalRolloff_Z_ID12_float(float3 vertexOS, out float3 retVertex)
{
    CurvedWorld_SpiralVerticalRolloff_Z_ID12(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_SpiralVerticalRolloff_Z_ID12_half(half3 vertexOS, out half3 retVertex)
{
    CurvedWorld_SpiralVerticalRolloff_Z_ID12(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_SpiralVerticalRolloff_Z_ID12_float(float3 vertexOS, float3 normalOS, float4 tangent, out float3 retVertex, out float3 retNormal)
{
	CurvedWorld_SpiralVerticalRolloff_Z_ID12(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;
}

void CurvedWorld_SpiralVerticalRolloff_Z_ID12_half(half3 vertexOS, half3 normalOS, half4 tangent, out half3 retVertex, out float3 retNormal)
{
	CurvedWorld_SpiralVerticalRolloff_Z_ID12(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;	
}     

#endif
