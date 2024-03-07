#ifndef CURVEDWORLD_SCENE_PICKING_CGINC
#define CURVEDWORLD_SCENE_PICKING_CGINC


#include "UnityCG.cginc"

#include "CurvedWorldTransform.cginc" 


//Variables/////////////////////////////////////////////////////////////
#ifdef _ALPHATEST_ON
	half        _Cutoff;
#endif
sampler2D   _MainTex;
float4      _MainTex_ST;

float _ObjectId;
float _PassValue;
float4 _SelectionID;
//Structs///////////////////////////////////////////////////////////////
struct VertexInput
{
    float4 vertex   : POSITION;
    fixed4 color    : COLOR;
    float2 texcoords : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct VertexOutput
{
    float2 texcoord : TEXCOORD0;
    fixed4 color : TEXCOORD2;
};

//Vertex////////////////////////////////////////////////////////////////
void vertEditorPass(VertexInput v, out VertexOutput o, out float4 opos : SV_POSITION)
{
	UNITY_SETUP_INSTANCE_ID(v);


    #if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
	    CURVEDWORLD_TRANSFORM_VERTEX(v.vertex);
    #endif


    opos = UnityObjectToClipPos(v.vertex);
    o.texcoord = TRANSFORM_TEX(v.texcoords.xy, _MainTex);
    o.color = v.color;
}

//Fragment//////////////////////////////////////////////////////////////
void fragSceneClip(VertexOutput i)
{
    half alpha = tex2D(_MainTex, i.texcoord).a;
    alpha *= i.color.a;

#ifdef _ALPHATEST_ON
    clip(alpha - _Cutoff);
#elif defined(_ALPHABLEND_ON) || defined(_ALPHAPREMULTIPLY_ON)
    clip(alpha - 0.2);
#elif defined(CUTOUT_0_3)
    clip(alpha-0.33);
#endif
}

half4 fragSceneHighlightPass(VertexOutput i) : SV_Target
{
    fragSceneClip(i);
    return float4(_ObjectId, _PassValue, 1, 1);
}

half4 fragScenePickingPass(VertexOutput i) : SV_Target
{
    //fragSceneClip(i);
    return _SelectionID;
}

#endif