#ifndef CURVEDWORLD_CYLINDRICALROLLOFF_X_ID25_CGINC
#define CURVEDWORLD_CYLINDRICALROLLOFF_X_ID25_CGINC

uniform float3 CurvedWorld_CylindricalRolloff_X_ID25_PivotPoint;
uniform float CurvedWorld_CylindricalRolloff_X_ID25_BendSize;    
uniform float CurvedWorld_CylindricalRolloff_X_ID25_BendOffset;
  
                 
#include "../../Core/Core.cginc"                           
             
      
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                Main Method                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_CylindricalRolloff_X_ID25(inout float4 vertexOS)
{
    CurvedWorld_CylindricalRolloff_X(vertexOS, 
	                        CurvedWorld_CylindricalRolloff_X_ID25_PivotPoint,
							CurvedWorld_CylindricalRolloff_X_ID25_BendSize,
							CurvedWorld_CylindricalRolloff_X_ID25_BendOffset);
}

void CurvedWorld_CylindricalRolloff_X_ID25(inout float4 vertexOS, inout float3 normalOS, float4 tangent)
{
    CurvedWorld_CylindricalRolloff_X(vertexOS, 
                            normalOS, 
                            tangent,
                            CurvedWorld_CylindricalRolloff_X_ID25_PivotPoint,
                            CurvedWorld_CylindricalRolloff_X_ID25_BendSize,
                            CurvedWorld_CylindricalRolloff_X_ID25_BendOffset);
}    

void CurvedWorld_CylindricalRolloff_X_ID25(inout float3 vertexOS)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_CylindricalRolloff_X_ID25(vertex);

    vertexOS.xyz = vertex.xyz;
}

void CurvedWorld_CylindricalRolloff_X_ID25(inout float3 vertexOS, inout float3 normalOS, float4 tangent)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_CylindricalRolloff_X_ID25(vertex, normalOS, tangent);

    vertexOS.xyz = vertex.xyz;
}  
                  
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                               SubGraph Methods                             //
//                                                                            // 
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_CylindricalRolloff_X_ID25_float(float3 vertexOS, out float3 retVertex)
{
    CurvedWorld_CylindricalRolloff_X_ID25(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_CylindricalRolloff_X_ID25_half(half3 vertexOS, out half3 retVertex)
{
    CurvedWorld_CylindricalRolloff_X_ID25(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_CylindricalRolloff_X_ID25_float(float3 vertexOS, float3 normalOS, float4 tangent, out float3 retVertex, out float3 retNormal)
{
	CurvedWorld_CylindricalRolloff_X_ID25(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;
}

void CurvedWorld_CylindricalRolloff_X_ID25_half(half3 vertexOS, half3 normalOS, half4 tangent, out half3 retVertex, out float3 retNormal)
{
	CurvedWorld_CylindricalRolloff_X_ID25(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;	
}     

#endif
