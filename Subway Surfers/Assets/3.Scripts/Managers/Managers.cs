using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Managers : MonoBehaviour
{
    static Managers instance;
    static Managers Instance { get { Init(); return instance; } }

    InputManager _input = new InputManager();

    public static InputManager Input { get { return Instance._input; } }

    void Start() => Init();

    static void Init()
    {
        if (instance == null)
        {
            GameObject go = GameObject.Find("@Managers");
            DontDestroyOnLoad(go);
            instance = go.GetComponent<Managers>();
        }
    }
}
