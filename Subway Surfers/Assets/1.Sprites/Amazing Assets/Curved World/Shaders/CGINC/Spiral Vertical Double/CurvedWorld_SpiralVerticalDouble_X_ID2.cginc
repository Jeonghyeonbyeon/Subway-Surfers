#ifndef CURVEDWORLD_SPIRALVERTICALDOUBLE_X_ID2_CGINC
#define CURVEDWORLD_SPIRALVERTICALDOUBLE_X_ID2_CGINC

uniform float3 CurvedWorld_SpiralVerticalDouble_X_ID2_PivotPoint;
uniform float3 CurvedWorld_SpiralVerticalDouble_X_ID2_RotationCenter;
uniform float3 CurvedWorld_SpiralVerticalDouble_X_ID2_RotationCenter2;
uniform float2 CurvedWorld_SpiralVerticalDouble_X_ID2_BendAngle;
uniform float2 CurvedWorld_SpiralVerticalDouble_X_ID2_BendMinimumRadius;

                 
#include "../../Core/Core.cginc"                           
             
      
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                Main Method                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_SpiralVerticalDouble_X_ID2(inout float4 vertexOS)
{
    CurvedWorld_SpiralVerticalDouble_X(vertexOS, 
							CurvedWorld_SpiralVerticalDouble_X_ID2_PivotPoint,
	                        CurvedWorld_SpiralVerticalDouble_X_ID2_RotationCenter,
							CurvedWorld_SpiralVerticalDouble_X_ID2_RotationCenter2,
							CurvedWorld_SpiralVerticalDouble_X_ID2_BendAngle,
							CurvedWorld_SpiralVerticalDouble_X_ID2_BendMinimumRadius);
}

void CurvedWorld_SpiralVerticalDouble_X_ID2(inout float4 vertexOS, inout float3 normalOS, float4 tangent)
{
    CurvedWorld_SpiralVerticalDouble_X(vertexOS, 
                            normalOS, 
                            tangent,
							CurvedWorld_SpiralVerticalDouble_X_ID2_PivotPoint,
                            CurvedWorld_SpiralVerticalDouble_X_ID2_RotationCenter,
							CurvedWorld_SpiralVerticalDouble_X_ID2_RotationCenter2,                            
							CurvedWorld_SpiralVerticalDouble_X_ID2_BendAngle,
							CurvedWorld_SpiralVerticalDouble_X_ID2_BendMinimumRadius);
}

void CurvedWorld_SpiralVerticalDouble_X_ID2(inout float3 vertexOS)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_SpiralVerticalDouble_X_ID2(vertex);

    vertexOS.xyz = vertex.xyz;
}

void CurvedWorld_SpiralVerticalDouble_X_ID2(inout float3 vertexOS, inout float3 normalOS, float4 tangent)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_SpiralVerticalDouble_X_ID2(vertex, normalOS, tangent);

    vertexOS.xyz = vertex.xyz;
} 

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                               SubGraph Methods                             //
//                                                                            // 
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_SpiralVerticalDouble_X_ID2_float(float3 vertexOS, out float3 retVertex)
{
    CurvedWorld_SpiralVerticalDouble_X_ID2(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_SpiralVerticalDouble_X_ID2_half(half3 vertexOS, out half3 retVertex)
{
    CurvedWorld_SpiralVerticalDouble_X_ID2(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_SpiralVerticalDouble_X_ID2_float(float3 vertexOS, float3 normalOS, float4 tangent, out float3 retVertex, out float3 retNormal)
{
	CurvedWorld_SpiralVerticalDouble_X_ID2(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;
}

void CurvedWorld_SpiralVerticalDouble_X_ID2_half(half3 vertexOS, half3 normalOS, half4 tangent, out half3 retVertex, out float3 retNormal)
{
	CurvedWorld_SpiralVerticalDouble_X_ID2(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;	
}     

#endif
