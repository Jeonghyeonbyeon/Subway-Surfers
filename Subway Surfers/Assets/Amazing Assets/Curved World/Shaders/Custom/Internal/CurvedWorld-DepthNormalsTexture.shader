

Shader "Hidden/Amazing Assets/CurvedWorld-DepthNormalsTexture" 
{
	Properties 
	{
        [CurvedWorldBendSettings] _CurvedWorldBendSettings("0|1|1", Vector) = (0, 0, 0, 0)


		_MainTex ("", 2D) = "white" {}
		_Cutoff ("", Float) = 0.5
		_Color ("", Color) = (1,1,1,1)
	}


SubShader   //CurvedWorld_Opaque
{
    Tags { "RenderType"="CurvedWorld_Opaque" }
    
    Pass 
    {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"



#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc" 



        struct v2f  
        {
            float4 pos : SV_POSITION;
            float4 nz : TEXCOORD0;
            UNITY_VERTEX_OUTPUT_STEREO
        };

        v2f vert( appdata_base v ) 
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);


            CURVEDWORLD_TRANSFORM_VERTEX(v.vertex);


            o.pos = UnityObjectToClipPos(v.vertex);
            o.nz.xyz = COMPUTE_VIEW_NORMAL;
            o.nz.w = COMPUTE_DEPTH_01;
            return o;
        }

        fixed4 frag(v2f i) : SV_Target 
        {
            return EncodeDepthNormal (i.nz.w, i.nz.xyz);
        }
        ENDCG
    }
}
 
    
SubShader   //CurvedWorld_TransparentCutout
{
    Tags { "RenderType"="CurvedWorld_TransparentCutout" }

    Pass 
    {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"



#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc" 


        struct v2f 
        {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
            float4 nz : TEXCOORD1;
            UNITY_VERTEX_OUTPUT_STEREO
        };
        
        uniform float4 _MainTex_ST;
        v2f vert( appdata_base v ) 
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);


            CURVEDWORLD_TRANSFORM_VERTEX(v.vertex);


            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
            o.nz.xyz = COMPUTE_VIEW_NORMAL;
            o.nz.w = COMPUTE_DEPTH_01;
            return o;
        }
        
        uniform sampler2D _MainTex;
        uniform fixed _Cutoff;
        uniform fixed4 _Color;
        fixed4 frag(v2f i) : SV_Target 
        {
            fixed4 texcol = tex2D( _MainTex, i.uv );
            clip( texcol.a*_Color.a - _Cutoff );
            return EncodeDepthNormal (i.nz.w, i.nz.xyz);
        }
        ENDCG
    }
}


SubShader    //CurvedWorld_TreeBark
{
    Tags { "RenderType"="CurvedWorld_TreeBark" }

    Pass 
    {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"
        #include "Lighting.cginc"
        #include "UnityBuiltin3xTreeLibrary.cginc"


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc" 


        struct v2f 
        {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
            float4 nz : TEXCOORD1;
            UNITY_VERTEX_OUTPUT_STEREO
        };
        v2f vert( appdata_full v ) 
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            TreeVertBark(v);


            CURVEDWORLD_TRANSFORM_VERTEX(v.vertex);


            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = v.texcoord.xy;
            o.nz.xyz = COMPUTE_VIEW_NORMAL;
            o.nz.w = COMPUTE_DEPTH_01;
            return o;
        }

        fixed4 frag( v2f i ) : SV_Target 
        {
            return EncodeDepthNormal (i.nz.w, i.nz.xyz);
        }
        ENDCG
    }
}


SubShader    //CurvedWorld_TreeLeaf
{
    Tags { "RenderType"="CurvedWorld_TreeLeaf" }

    Pass 
    {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"
        #include "Lighting.cginc"
        #include "UnityBuiltin3xTreeLibrary.cginc"


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc" 

        struct v2f 
        {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
            float4 nz : TEXCOORD1;
            UNITY_VERTEX_OUTPUT_STEREO
        };
        v2f vert( appdata_full v ) 
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            TreeVertLeaf(v);


            CURVEDWORLD_TRANSFORM_VERTEX(v.vertex);


            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = v.texcoord.xy;
            o.nz.xyz = COMPUTE_VIEW_NORMAL;
            o.nz.w = COMPUTE_DEPTH_01;
            return o;
        }

        uniform sampler2D _MainTex;
        uniform fixed _Cutoff;

        fixed4 frag( v2f i ) : SV_Target 
        {
            half alpha = tex2D(_MainTex, i.uv).a;

            clip (alpha - _Cutoff);
            return EncodeDepthNormal (i.nz.w, i.nz.xyz);
        }
        ENDCG
    }
}


SubShader    //CurvedWorld_TreeBillboard
{
    Tags { "RenderType"="CurvedWorld_TreeBillboard" }

    Pass 
    {
        Cull Off
        CGPROGRAM

        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        #include "TerrainEngine.cginc"


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc" 


        struct v2f 
        {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
            float4 nz : TEXCOORD1;
            UNITY_VERTEX_OUTPUT_STEREO
        };
        v2f vert (appdata_tree_billboard v) 
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            TerrainBillboardTree(v.vertex, v.texcoord1.xy, v.texcoord.y);


            CURVEDWORLD_TRANSFORM_VERTEX(v.vertex);


            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv.x = v.texcoord.x;
            o.uv.y = v.texcoord.y > 0;
            o.nz.xyz = float3(0,0,1);
            o.nz.w = COMPUTE_DEPTH_01;
            return o;
        }

        uniform sampler2D _MainTex;

        fixed4 frag(v2f i) : SV_Target 
        {
            fixed4 texcol = tex2D( _MainTex, i.uv );
            clip( texcol.a - 0.001 );
            return EncodeDepthNormal (i.nz.w, i.nz.xyz);
        }
        ENDCG
    }
}


SubShader    //CurvedWorld_GrassBillboard
{
    Tags { "RenderType"="CurvedWorld_GrassBillboard" }

    Pass 
    {
        Cull Off
        CGPROGRAM

        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        #include "TerrainEngine.cginc"


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc" 


        struct v2f 
        {
            float4 pos : SV_POSITION;
            fixed4 color : COLOR;
            float2 uv : TEXCOORD0;
            float4 nz : TEXCOORD1;
            UNITY_VERTEX_OUTPUT_STEREO
        };

        v2f vert (appdata_full v) 
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            WavingGrassBillboardVert (v);


            CURVEDWORLD_TRANSFORM_VERTEX(v.vertex);


            o.color = v.color;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = v.texcoord.xy;
            o.nz.xyz = COMPUTE_VIEW_NORMAL;
            o.nz.w = COMPUTE_DEPTH_01;
            return o;
        }

        uniform sampler2D _MainTex;
        uniform fixed _Cutoff;

        fixed4 frag(v2f i) : SV_Target 
        {
            fixed4 texcol = tex2D( _MainTex, i.uv );
            fixed alpha = texcol.a * i.color.a;
            clip( alpha - _Cutoff );
            return EncodeDepthNormal (i.nz.w, i.nz.xyz);
        }
        ENDCG
    }
}


SubShader    //CurvedWorld_Grass
{
    Tags { "RenderType"="CurvedWorld_Grass" }

    Pass 
    {
        Cull Off
        CGPROGRAM

        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        #include "TerrainEngine.cginc"


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc" 


        struct v2f 
        {
            float4 pos : SV_POSITION;
            fixed4 color : COLOR;
            float2 uv : TEXCOORD0;
            float4 nz : TEXCOORD1;
            UNITY_VERTEX_OUTPUT_STEREO
        };

        v2f vert (appdata_full v) 
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            WavingGrassVert (v);


            CURVEDWORLD_TRANSFORM_VERTEX(v.vertex);


            o.color = v.color;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = v.texcoord;
            o.nz.xyz = COMPUTE_VIEW_NORMAL;
            o.nz.w = COMPUTE_DEPTH_01;
            return o;
        }

        uniform sampler2D _MainTex;
        uniform fixed _Cutoff;

        fixed4 frag(v2f i) : SV_Target 
        {
            fixed4 texcol = tex2D( _MainTex, i.uv );
            fixed alpha = texcol.a * i.color.a;
            clip( alpha - _Cutoff );
            return EncodeDepthNormal (i.nz.w, i.nz.xyz);
        }
        ENDCG
    }
}

 
//  Fallback "Hidden/Internal-DepthNormalsTexture"
}
