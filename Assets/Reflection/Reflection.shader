﻿// Digital Camera only

Shader "haquxx/Reflection"
{
    Properties
    {
        _RefTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 ref : TEXCOORD1;
            };

            sampler2D _RefTex;
            float4 _RefTex_ST;
            float4x4 _RefM;
            float4x4 _RefV;
            float4x4 _RefP;
            float4x4 _RefVP;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.ref = mul(_RefVP, mul(_RefM, v.vertex));
                o.uv = TRANSFORM_TEX(v.uv, _RefTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                float2 uv = i.ref.xy / i.ref.w * 0.5 + 0.5;
                fixed4 col = tex2D(_RefTex, uv);

                return col;
            }
            ENDCG
        }
    }
}
